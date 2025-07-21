import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import '/widgets/emergency_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 16,
          ), // agar tidak terlalu mepet
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 22),
              _Greetings(),
              SizedBox(height: 22),
              _BannerCard(),
              SizedBox(height: 22),
              EmergencyKitSlider(),
            ],
          ),
        ),
      ),
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
                  colors: [Color(0xFF00009C), Color(0xFFA80000)],
                ).createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
            child: const Text(
              'Curativo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                    color: Color(0xFFA80000),
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
                borderRadius: BorderRadius.all(Radius.circular(8)),
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
            children: [
              EmergencyKitCard(
                title: 'Pertolongan Pertama',
                description: '🩺 Langkah awal saat darurat.',
                imageAsset: 'assets/images/first-aid.png',
                steps: [
                  {
                    'title': 'Cek Kesadaran',
                    'description': 'Pastikan korban sadar.',
                  },
                  {
                    'title': 'Hubungi Bantuan',
                    'description': 'Telepon 112/119.',
                  },
                ],
              ),
              EmergencyKitCard(
                title: 'Perlengkapan P3K',
                description: '🩹 Perawatan luka kecil.',
                imageAsset: 'assets/images/p3k.png',
                steps: [
                  {
                    'title': 'Perlengkapan P3K',
                    'imageAsset': 'assets/images/p3k.png',
                    'description':
                        'Perlengkapan pertolongan pertama dapat membantu kita ketika terjadi keadaan darurat.',
                  },
                  {
                    'title': 'Barang Keperluan Pribadi',
                    'description': '1. Sarung tangan non steril satu kali pakai\n2. Sabun cuci tangan\n3. Kantong ziplock\n4. Handuk',
                  },
                  {
                    'title': 'Perlengkapan P3K - Perban',
                    'description': '1. Perban elastis atau gulung\n2. Perban segitiga atau mitela\n3. Perban kasa\n4. Kompres kasa steril dan non steril\n5. Pita perban perekat\n6. Plester luka\n7. Pembalut non perekat',
                  },
                  {
                    'title': 'Perlengkapan P3K - Instrumen dan barang-barang penting',
                    'description': '1. Gunting\n2. Pinset splinter\n3. Pinset biasa\n4. Peniti\n5. Kompres dingin atau es\n6. Bidai\n7. Sendok takar\n8. Garam rehidrasi atau oralit',
                  },
                ],
              ),
              EmergencyKitCard(
                title: 'CPR Darurat',
                description: '❤️ Bantuan hidup dasar.',
                imageAsset: 'assets/images/cpr.png',
                steps: [
                  {
                    'title': 'Cek Kesadaran',
                    'description': 'Pastikan korban sadar.',
                  },
                  {
                    'title': 'Hubungi Bantuan',
                    'description': 'Telepon 112/119.',
                  },
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
