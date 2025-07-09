import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import '/widgets/custom_bottom_navbar.dart';
import '/widgets/emergency_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            SizedBox(height: 22),
            _Greetings(),
            SizedBox(height: 22),
            _BannerCard(),
            SizedBox(height: 22),
            EmergencyKitSlider(),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}

class _Greetings extends StatelessWidget {
  const _Greetings();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShaderMask(
            shaderCallback:
                (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF00009C), // warna awal
                    Color(0xFFA80000), // warna akhir
                  ],
                ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
            child: const Text(
              'Curativo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // penting: harus putih untuk efek gradient
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(FeatherIcons.bell, color: Color(0xFFA80000)),
              ),
              Positioned(
                right: 10,
                top: 5,
                child: Container(
                  height: 15,
                  width: 15,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA80000),
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: const Center(
                    child: Text(
                      "2",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA80000), Color(0xFFF8D7DA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Yuk, Cek\nKondisi Luka!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Mari deteksi dan pantau luka sejak dini',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.asset(
                  'assets/images/band-aid.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyKitSlider extends StatelessWidget {
  const EmergencyKitSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kit Siaga',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Pastikan kamu siap bantu penanganan luka',
                style: TextStyle(fontSize: 14, color: Color(0xFF6D6D6D)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              EmergencyKitCard(
                title: 'Pertolongan Pertama',
                description: '🩺 Langkah awal saat darurat.',
                imageAsset: 'assets/images/first-aid.png',
              ),
              EmergencyKitCard(
                title: 'P3K Luka Ringan',
                description: '🩹 Perawatan luka kecil.',
                imageAsset: 'assets/images/p3k.png',
              ),
              EmergencyKitCard(
                title: 'CPR Darurat',
                description: '❤️ Bantuan hidup dasar.',
                imageAsset: 'assets/images/cpr.png',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
