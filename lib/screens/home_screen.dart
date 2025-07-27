import 'package:flutter/material.dart';
import '/widgets/headers/gradient_header.dart';
import '/widgets/cards/action_banner_card.dart';
import '/widgets/lists/kit_slider_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _kitItems = [
    {
      'title': 'Pertolongan Pertama',
      'description': '🚑 Bantuan medis darurat.',
      'imageAsset': 'assets/images/first-aid.png',
      'steps': [
        {
          'title': 'Cek Kesadaran',
          'description': 'Pastikan korban sadar.',
        },
        {
          'title': 'Hubungi Bantuan',
          'description': 'Telepon 112/119.',
        },
      ],
    },
    {
      'title': 'P3K Luka Ringan',
      'description': '🩹 Perawatan luka kecil.',
      'imageAsset': 'assets/images/p3k.png',
      'steps': [
        {
          'title': 'Perlengkapan P3K',
          'description': 'Perlengkapan pertolongan pertama dapat membantu kita ketika terjadi keadaan darurat.',
        },
        {
          'title': 'Hubungi Bantuan',
          'description': 'Telepon 112/119.',
        },
      ],
    },
    {
      'title': 'CPR Darurat',
      'description': '❤️ Bantuan hidup dasar.',
      'imageAsset': 'assets/images/cpr.png',
      'steps': [
        {
          'title': 'Cek Kesadaran',
          'description': 'Pastikan korban sadar.',
        },
        {
          'title': 'Hubungi Bantuan',
          'description': 'Telepon 112/119.',
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header dengan gradient yang konsisten
              const GradientHeader(
                title: 'Curativo',
                subtitle: 'Solusi cerdas untuk perawatan luka',
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
              const SizedBox(height: 24),
              // Banner card dengan tema yang konsisten
              ActionBannerCard(
                title: 'Yuk, Cek\nKondisi Luka!',
                subtitle: 'Mari deteksi dan pantau luka sejak dini',
                imageAsset: 'assets/images/band-aid.png',
                gradientColors: const [Color(0xFFA80000), Color(0xFFF8D7DA)],
                onTap: () {
                  // Navigate to scan screen
                  // Navigator.pushNamed(context, '/scan');
                },
              ),
              const SizedBox(height: 28),
              // Section kit dengan styling yang dipercantik
              KitSliderSection(
                title: 'Kit Siaga',
                subtitle: 'Pastikan kamu siap bantu penanganan luka',
                kitItems: _kitItems,
                height: 240,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
