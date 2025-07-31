import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart'; // Import untuk mendukung multi-bahasa
import '../widgets/headers/gradient_header.dart'; // Widget header dengan efek gradien
import '../widgets/cards/action_banner_card.dart'; // Widget banner aksi dengan gambar dan teks
import '../widgets/lists/kit_slider_section.dart'; // Widget slider untuk daftar kit pertolongan pertama

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Fungsi untuk menghasilkan daftar item kit pertolongan pertama
  // Menggunakan `localizations` agar teks dapat berubah sesuai bahasa pengguna
  List<Map<String, dynamic>> _getKitItems(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      {
        // Item 1: Tips Kit Siaga Luka
        'title': localizations.firstAidTitle,
        'description': localizations.firstAidDescription,
        'imageAsset': 'assets/images/first-aid.png',
        'steps': [
          {
            'title': localizations.preparednessKit,
            'description': localizations.preparednessKitDesc,
          },
          {
            'title': localizations.callHelp,
            'description': localizations.callHelpDesc,
          },
        ],
      },
      {
        // Item 2: Perawatan luka ringan
        'title': localizations.minorWoundCare,
        'description': localizations.minorWoundDesc,
        'imageAsset': 'assets/images/p3k.png',
        'steps': [
          {
            'title': localizations.firstAidEquipment1, // Perlu ada di file ARB
            'description': localizations.firstAidEquipmentDesc1,
          },
          {
            'title': localizations.firstAidEquipment2, 
            'description': localizations.firstAidEquipmentDesc2,
          },
          {
            'title': localizations.firstAidEquipment3, 
            'description': localizations.firstAidEquipmentDesc3,
          },
          {
            'title': localizations.firstAidEquipment4, 
            'description': localizations.firstAidEquipmentDesc4,
          },
          {
            'title': localizations.firstAidEquipment5, 
            'description': localizations.firstAidEquipmentDesc5,
          },
          {
            'title': localizations.callHelp,
            'description': localizations.callHelpDesc,
          },
        ],
      },
      {
        // Item 3: tas darurat
        'title': localizations.emergencyBagTitle,
        'description': localizations.emergencyBagDescription,
        'imageAsset': 'assets/images/emergency_bag.jpg',
        'steps': [
          {
            'title': localizations.emergencyBag,
            'description': localizations.emergencyBagDesc,
          },
          {
            'title': localizations.callHelp,
            'description': localizations.callHelpDesc,
          },
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context)!; // Ambil instance localization aktif
    final kitItems = _getKitItems(
      context,
    ); // Generate item kit pertolongan pertama

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Warna latar belakang layar
      body: SafeArea(
        // Mencegah overlap dengan area sistem (notch, status bar)
        child: SingleChildScrollView(
          // Memungkinkan layar di-scroll jika kontennya panjang
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20), // Spasi atas
              // Header dengan judul dan subjudul bergradasi
              GradientHeader(
                title:
                    localizations
                        .appTitle, // Judul aplikasi (misal: "Curativo")
                subtitle:
                    localizations
                        .homeSubtitle, // Subjudul (misal: "Panduan Pertolongan Pertama")
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),

              const SizedBox(height: 24), // Spasi antara header dan banner
              // Banner aksi utama dengan gambar dan efek gradasi warna
              ActionBannerCard(
                title: localizations.checkWoundCondition, // Teks ajakan
                subtitle:
                    localizations.checkWoundSubtitle, // Penjelasan singkat
                imageAsset: 'assets/images/band-aid.png',
                gradientColors: const [
                  Color(0xFFA80000),
                  Color(0xFFF8D7DA),
                ], // Gradasi merah muda
                onTap: () {
                  // Aksi ketika banner ditekan, bisa diarahkan ke halaman scan
                  // Navigator.pushNamed(context, '/scan');
                },
              ),

              const SizedBox(height: 28), // Spasi sebelum slider kit
              // Slider berisi daftar kit pertolongan pertama dengan animasi horizontal
              KitSliderSection(
                title: localizations.emergencyKit, // Judul section
                subtitle:
                    localizations.emergencyKitSubtitle, // Subjudul section
                kitItems: kitItems, // Data yang ditampilkan dalam slider
                height: 240, // Tinggi slider
              ),

              const SizedBox(height: 20), // Spasi bawah
            ],
          ),
        ),
      ),
    );
  }
}
