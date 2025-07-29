import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart'; // Localization untuk multi-bahasa
import 'home_screen.dart'; // Halaman utama
import 'aid_screen.dart'; // Halaman bantuan pertolongan pertama
import 'scan_screen.dart'; // Halaman pemindaian luka
import 'history_screen.dart'; // Halaman riwayat hasil scan
import 'profile_screen.dart'; // Halaman profil pengguna

// MainTabView adalah tampilan utama aplikasi dengan navigasi tab bawah
class MainTabView extends StatefulWidget {
  final Function(Locale)?
  onLanguageChanged; // Callback opsional untuk mengganti bahasa aplikasi

  const MainTabView({super.key, this.onLanguageChanged});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _selectedIndex = 0; // Menyimpan tab yang sedang aktif

  // GlobalKey untuk mengakses dan menyegarkan data pada HistoryScreen
  final GlobalKey<HistoryScreenState> _historyKey =
      GlobalKey<HistoryScreenState>();

  late List<Widget> _pages; // Menyimpan semua halaman/tab

  @override
  void initState() {
    super.initState();
    // Inisialisasi semua halaman/tab yang tersedia
    _pages = [
      const HomeScreen(), // Beranda
      const AidScreen(), // Bantuan/penanganan
      ScanScreen(
        // Saat scan selesai, refresh halaman riwayat dan pindah ke tab riwayat
        onScanCompleted: () {
          _historyKey.currentState
              ?.refreshHistory(); // Panggil fungsi refresh di riwayat
          setState(() {
            _selectedIndex = 3; // Pindah ke tab riwayat (indeks ke-3)
          });
        },
      ),
      HistoryScreen(key: _historyKey), // Riwayat dengan GlobalKey
      ProfileScreen(onLanguageChanged: widget.onLanguageChanged), // Profil
    ];
  }

  // Fungsi untuk mengubah tab yang sedang aktif
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Helper untuk membuat item navigasi tab bawah
  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context)!; // Ambil lokal bahasa aktif

    return Scaffold(
      // Menampilkan hanya satu halaman aktif, namun mempertahankan state halaman lain
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // Navigasi tab bawah
      bottomNavigationBar: BottomNavigationBar(
        type:
            BottomNavigationBarType
                .fixed, // Menampilkan semua tab (tidak shifting)
        currentIndex: _selectedIndex, // Tab aktif
        onTap: _onItemTapped, // Fungsi saat salah satu tab ditekan
        selectedItemColor: const Color.fromARGB(
          255,
          156,
          8,
          0,
        ), // Warna tab aktif
        unselectedItemColor: const Color(0xFF6D6D6D), // Warna tab tidak aktif
        backgroundColor: Colors.white,

        items: [
          // Tab: Home
          _buildNavItem(Icons.home, localizations.home),

          // Tab: Pertolongan Pertama
          _buildNavItem(Icons.medical_services, localizations.help),

          // Tab: Scan (tampilan kustom dengan latar merah dan ikon putih)
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 156, 8, 0), // Merah
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.qr_code_scanner, color: Colors.white),
                  const SizedBox(height: 4),
                  Text(
                    localizations.scan, // Label "Pindai"
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            label: ' ', // Label dikosongkan karena sudah tertulis di atas
          ),

          // Tab: Riwayat
          _buildNavItem(Icons.history, localizations.history),

          // Tab: Akun/Profil
          _buildNavItem(Icons.person_outline, localizations.account),
        ],
      ),
    );
  }
}
