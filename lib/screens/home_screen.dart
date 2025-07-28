import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import '../widgets/headers/gradient_header.dart';
import '../widgets/cards/action_banner_card.dart';
import '../widgets/lists/kit_slider_section.dart';
// Hapus import language_switcher

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // Hapus onLanguageChanged parameter

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _getKitItems(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return [
      {
        'title': localizations.firstAidTitle,
        'description': localizations.firstAidDescription,
        'imageAsset': 'assets/images/first-aid.png',
        'steps': [
          {
            'title': localizations.checkConsciousness,
            'description': localizations.checkConsciousnessDesc,
          },
          {
            'title': localizations.callHelp,
            'description': localizations.callHelpDesc,
          },
        ],
      },
      {
        'title': localizations.minorWoundCare, // Gunakan localization
        'description': localizations.minorWoundDesc, // Gunakan localization
        'imageAsset': 'assets/images/p3k.png',
        'steps': [
          {
            'title': localizations.firstAidEquipment, // Perlu ditambahkan ke ARB
            'description': localizations.firstAidEquipmentDesc, // Perlu ditambahkan ke ARB
          },
          {
            'title': localizations.callHelp,
            'description': localizations.callHelpDesc,
          },
        ],
      },
      {
        'title': localizations.emergencyCPR, // Gunakan localization
        'description': localizations.emergencyCPRDesc, // Gunakan localization
        'imageAsset': 'assets/images/cpr.png',
        'steps': [
          {
            'title': localizations.checkConsciousness,
            'description': localizations.checkConsciousnessDesc,
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
    final localizations = AppLocalizations.of(context)!;
    final kitItems = _getKitItems(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              GradientHeader(
                title: localizations.appTitle,
                subtitle: localizations.homeSubtitle,
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
              const SizedBox(height: 24), // Dikurangi dari 24 menjadi 12
              // Banner card dengan tema yang konsisten
              ActionBannerCard(
                title: localizations.checkWoundCondition,
                subtitle: localizations.checkWoundSubtitle,
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
                title: localizations.emergencyKit,
                subtitle: localizations.emergencyKitSubtitle,
                kitItems: kitItems, // Changed from _kitItems to kitItems
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
