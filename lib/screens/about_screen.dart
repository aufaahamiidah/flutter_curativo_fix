import 'package:flutter/material.dart';
import 'package:flutter_curativo/widgets/common/custom_app_bar.dart';
import 'package:flutter_curativo/widgets/cards/app_info_card.dart';
import 'package:flutter_curativo/widgets/lists/feature_highlight.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Tentang Aplikasi',
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF000080),
                    Color(0xFF0066CC),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF000080).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
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
                  const Text(
                    'Curativo',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'v1.0.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Aplikasi deteksi luka menggunakan AI untuk memberikan rekomendasi perawatan yang tepat',
                    style: TextStyle(
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
            
            // Features Section
            const Text(
              'Fitur Utama',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            
            const FeatureHighlight(
              icon: Icons.camera_alt,
              title: 'Deteksi Luka ',
              description: 'Scan luka menggunakan kamera untuk identifikasi jenis luka',
              accentColor: Color(0xFF4CAF50),
            ),
            const SizedBox(height: 12),
            
            const FeatureHighlight(
              icon: Icons.psychology,
              title: 'AI Analisis',
              description: 'Teknologi AI canggih untuk analisis ',
              accentColor: Color(0xFF2196F3),
            ),
            const SizedBox(height: 12),
            
            const FeatureHighlight(
              icon: Icons.medical_services,
              title: 'Rekomendasi Perawatan',
              description: 'Saran perawatan berdasarkan jenis luka yang terdeteksi',
              accentColor: Color(0xFFFF9800),
            ),
            const SizedBox(height: 12),
            
            const FeatureHighlight(
              icon: Icons.history,
              title: 'Riwayat Pemindaian',
              description: 'Simpan dan lihat kembali hasil pemindaian sebelumnya',
              accentColor: Color(0xFF9C27B0),
            ),
            
            const SizedBox(height: 24),
            
            // Info Cards
            const Text(
              'Informasi Aplikasi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            
            AppInfoCard(
              icon: Icons.group,
              title: 'Tim Pengembang',
              subtitle: 'GreenMonkey Team',
              iconColor: const Color(0xFF4CAF50),
            ),
                        
            AppInfoCard(
              icon: Icons.support,
              title: 'Dukungan',
              subtitle: 'Hubungi kami untuk bantuan dan saran',
              iconColor: const Color(0xFF9C27B0),
            ),
            
            const SizedBox(height: 24),
            
            // Disclaimer
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
                        Text(
                          'Disclaimer',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Aplikasi ini hanya untuk referensi. Selalu konsultasikan dengan tenaga medis profesional untuk diagnosis dan perawatan yang tepat.',
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
