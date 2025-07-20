import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
// import '/widgets/custom_bottom_navbar.dart';

class AidScreen extends StatefulWidget {
  const AidScreen({super.key});

  @override
  State<AidScreen> createState() => _AidScreenState();
}

class _AidScreenState extends State<AidScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Berikan Bantuan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Image.asset(
                    'assets/images/home_plus.png',
                    width: 70,
                    height: 70,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const _BannerCard(),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Konten Darurat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _EmergencyTile(
                    title: 'Tersedak (Dewasa, Lansia)',
                    onTap:
                        () => _showEmergencyModal(
                          context,
                          'Tersedak (Dewasa, Lansia)',
                          'Jika seseorang dewasa atau lansia tersedak dan masih bisa batuk atau bersuara, biarkan mereka batuk untuk mencoba mengeluarkan objek tersebut. Jika tidak bisa bernapas atau bicara, lakukan Heimlich maneuver.',
                        ),
                  ),
                  const SizedBox(height: 8),
                  _EmergencyTile(
                    title: 'Tersedak (Anak Kecil)',
                    onTap:
                        () => _showEmergencyModal(
                          context,
                          'Tersedak (Anak Kecil)',
                          'Untuk anak kecil, posisikan mereka membungkuk ke depan dan tepuk punggung mereka lima kali dengan telapak tangan. Jika tidak berhasil, lakukan dorongan perut.',
                        ),
                  ),
                  const SizedBox(height: 8),
                  _EmergencyTile(
                    title: 'Tersedak (Bayi)',
                    onTap:
                        () => _showEmergencyModal(
                          context,
                          'Tersedak (Bayi)',
                          'Letakkan bayi telungkup di lengan Anda, kepala lebih rendah dari tubuh. Berikan lima tepukan di punggung, lalu lima tekanan dada jika belum berhasil.',
                        ),
                  ),
                  const SizedBox(height: 8),
                  _EmergencyTile(
                    title: 'Pendarahan Parah',
                    onTap:
                        () => _showEmergencyModal(
                          context,
                          'Pendarahan Parah',
                          'Tekan langsung area yang berdarah dengan kain bersih. Jangan lepaskan tekanan sampai bantuan medis tiba. Jika memungkinkan, angkat bagian tubuh yang berdarah.',
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }

  void _showEmergencyModal(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder:
              (_, controller) => Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    ListView(
                      controller: controller,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          content,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 330 / 130,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFFA80000),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(FeatherIcons.phone, color: Colors.white, size: 36),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kontak Darurat\n112',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Indonesia',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _EmergencyTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.chevron_right, color: Colors.red),
          ],
        ),
      ),
    );
  }
}
