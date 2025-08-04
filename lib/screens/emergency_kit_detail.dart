import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart'; // Tambahkan import ini

/// Halaman detail untuk menampilkan langkah-langkah penggunaan emergency kit
class EmergencyKitDetailPage extends StatefulWidget {
  final String title; // Judul utama
  final String description; // Deskripsi umum
  final String
  imageAsset; // Gambar utama (opsional, tidak digunakan dalam build)
  final List<Map<String, String>> steps; // Daftar langkah-langkah

  const EmergencyKitDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.steps,
  });

  @override
  State<EmergencyKitDetailPage> createState() => _EmergencyKitDetailPageState();
}

class _EmergencyKitDetailPageState extends State<EmergencyKitDetailPage> {
  // Controller untuk mengontrol PageView
  final PageController _pageController = PageController();

  // Index halaman saat ini
  int _currentPage = 0;

  // Daftar item kartu (langkah-langkah)
  late final List<Map<String, String>> cardItems;

  @override
  void initState() {
    super.initState();
    cardItems = widget.steps;

    // Menambahkan listener untuk mendeteksi perubahan halaman
    _pageController.addListener(() {
      final next = _pageController.page?.round() ?? 0;
      if (_currentPage != next) {
        setState(() => _currentPage = next);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Bersihkan controller saat widget dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!; // Tambahkan ini
    
    return Scaffold(
      backgroundColor: const Color(0xFF000054), // Latar belakang biru tua
      body: Stack(
        children: [
          // PageView untuk swipe antar langkah
          PageView.builder(
            controller: _pageController,
            itemCount: cardItems.length,
            itemBuilder: (context, index) {
              final item = cardItems[index];

              return Center(
                child: SizedBox(
                  width: 330,
                  height: 620,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Bagian gambar di atas kartu (jika tersedia)
                        if (item['imageAsset'] != null && item['imageAsset']!.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.asset(
                              item['imageAsset']!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.fill, // Gambar akan mengisi seluruh area (mungkin terdistorsi)
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200, // Samakan dengan tinggi gambar
                                  color: Colors.grey[300],
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        localizations.noImage,// Ganti 'Gambar tidak tersedia' dengan ini
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                        // Bagian konten teks dari kartu
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Judul langkah
                                Text(
                                  item['title'] ?? '',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Deskripsi langkah yang bisa di-scroll
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Text(
                                      item['description'] ?? '',
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Tombol untuk menutup halaman
          Positioned(
            top: 40,
            right: 16,
            child: GestureDetector(
              onTap:
                  () => Navigator.pop(context), // Kembali ke halaman sebelumnya
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          // Indikator bulatan di bawah (sebagai tanda halaman aktif)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                cardItems.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: _currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color:
                        _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
