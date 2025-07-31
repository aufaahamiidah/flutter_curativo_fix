import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import 'package:flutter_curativo/widgets/common/custom_app_bar.dart';
import 'package:flutter_curativo/widgets/cards/app_info_card.dart';
import 'package:flutter_curativo/widgets/lists/feature_highlight.dart';

// Widget stateless untuk halaman informasi tentang aplikasi
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil teks lokal dari file lokal (internationalization)
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      // Menggunakan AppBar kustom yang diberi judul dari lokal
      appBar: CustomAppBar(title: localizations.aboutApp),
      // Mengatur warna latar belakang halaman
      backgroundColor: const Color(0xFFFAFAFA),
      // Membungkus seluruh isi halaman dengan ScrollView agar bisa discroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==============================
            // Kartu Header Aplikasi
            // ==============================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE53E3E), // Warna gradasi merah
                    Color(0xFFD53F8C), // Warna gradasi pink
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(
                      0xFF000080,
                    ).withOpacity(0.3), // Bayangan biru gelap
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Gambar ikon aplikasi
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/Curativo.png',
                        width: 48,
                        height: 48,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Judul/Nama aplikasi
                  const Text(
                    'Curativo',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Label versi aplikasi
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      localizations.version,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Deskripsi aplikasi
                  Text(
                    localizations.appDescription,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ==============================
            // Seksi Fitur Utama Aplikasi
            // ==============================
            Text(
              localizations.mainFeatures,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),

            // Fitur 1: Deteksi Luka
            FeatureHighlight(
              icon: Icons.camera_alt,
              title: localizations.woundDetection,
              description: localizations.woundDetectionDesc,
              accentColor: const Color(0xFF4CAF50), // Hijau
            ),
            const SizedBox(height: 12),

            // Fitur 2: Analisis AI
            FeatureHighlight(
              icon: Icons.psychology,
              title: localizations.aiAnalysis,
              description: localizations.aiAnalysisDesc,
              accentColor: const Color(0xFF2196F3), // Biru
            ),
            const SizedBox(height: 12),

            // Fitur 3: Rekomendasi Penanganan
            FeatureHighlight(
              icon: Icons.medical_services,
              title: localizations.treatmentRecommendationFeature,
              description: localizations.treatmentRecommendationFeatureDesc,
              accentColor: const Color(0xFFFF9800), // Oranye
            ),
            const SizedBox(height: 12),

            // Fitur 4: Riwayat Scan
            FeatureHighlight(
              icon: Icons.history,
              title: localizations.scanHistoryFeature,
              description: localizations.scanHistoryFeatureDesc,
              accentColor: const Color(0xFF9C27B0), // Ungu
            ),

            const SizedBox(height: 24),

            // ==============================
            // Seksi Informasi Tambahan
            // ==============================
            Text(
              localizations.appInfo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),

            // Info: Tim Pengembang
            AppInfoCard(
              icon: Icons.group,
              title: localizations.developmentTeam,
              subtitle: localizations.greenMonkeyTeam,
              iconColor: const Color(0xFF4CAF50),
            ),

            // Info: Dukungan & Bantuan
            AppInfoCard(
              icon: Icons.support,
              title: localizations.support,
              subtitle: localizations.supportDesc,
              iconColor: const Color(0xFF9C27B0),
            ),

            const SizedBox(height: 24),

            // ==============================
            // Disclaimer (Penafian)
            // ==============================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul disclaimer
                        Text(
                          localizations.disclaimer,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[700],
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Isi penjelasan disclaimer
                        Text(
                          localizations.disclaimerText,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[800],
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
