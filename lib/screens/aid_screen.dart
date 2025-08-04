// Import library Flutter bawaan
import 'package:flutter/material.dart';

// Import localization untuk mendukung fitur multibahasa
import 'package:flutter_curativo/l10n/app_localizations.dart';

// Import ikon Feather
import 'package:feather_icons/feather_icons.dart';

// Import custom widget untuk halaman darurat
import '../widgets/emergency/emergency_header.dart';
import '../widgets/emergency/emergency_contact_card.dart';
import '../widgets/emergency/emergency_action_card.dart';
import '../widgets/headers/section_header.dart';

/// Widget Stateful yang digunakan untuk halaman 'Pertolongan Pertama'
class AidScreen extends StatefulWidget {
  const AidScreen({super.key});

  @override
  State<AidScreen> createState() => _AidScreenState();
}

class _AidScreenState extends State<AidScreen> {
  @override
  Widget build(BuildContext context) {
    // Ambil instance AppLocalizations untuk menerjemahkan teks sesuai bahasa
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // Warna latar belakang keseluruhan layar
      body: Column(
        children: [
          /// Header darurat dengan judul dan ikon ilustrasi
          EmergencyHeader(
            title: localizations.giveHelp,
            subtitle: localizations.emergencyFirstAidGuide,
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                'assets/images/home_plus.png',
                width: 40,
                height: 40,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// Kartu informasi untuk nomor darurat 112
          EmergencyContactCard(
            title: localizations.emergencyContact112,
            subtitle: localizations.emergencyContactDesc,
            phoneNumber: '112',
            icon: FeatherIcons.phone,
          ),

          const SizedBox(height: 24),

          /// Header seksi untuk daftar tindakan darurat
          SectionHeader(
            title: localizations.emergencyGuide,
            subtitle: localizations.emergencySteps,
          ),

          const SizedBox(height: 8),

          /// Daftar tindakan darurat dalam bentuk kartu
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                /// Setiap EmergencyActionCard menampilkan jenis tindakan, deskripsi, ikon, dan fungsi saat ditekan
                EmergencyActionCard(
                  title: localizations.chokingAdult,
                  subtitle: localizations.chokingAdultDesc,
                  icon: Icons.person,
                  onTap:
                      () => _showEmergencyModal(
                        context,
                        localizations.chokingAdult,
                        localizations.chokingAdultInstructions,
                      ),
                ),
                EmergencyActionCard(
                  title: localizations.chokingChild,
                  subtitle: localizations.chokingChildDesc,
                  icon: Icons.child_care,
                  onTap:
                      () => _showEmergencyModal(
                        context,
                        localizations.chokingChild,
                        localizations.chokingChildInstructions,
                      ),
                ),
                EmergencyActionCard(
                  title: localizations.chokingBaby,
                  subtitle: localizations.chokingBabyDesc,
                  icon: Icons.baby_changing_station,
                  onTap:
                      () => _showEmergencyModal(
                        context,
                        localizations.chokingBaby,
                        localizations.chokingBabyInstructions,
                      ),
                ),
                EmergencyActionCard(
                  title: localizations.severeBleeding,
                  subtitle: localizations.severeBleedingDesc,
                  icon: Icons.bloodtype,
                  onTap:
                      () => _showEmergencyModal(
                        context,
                        localizations.severeBleeding,
                        localizations.severeBleedingInstructions,
                      ),
                ),
                EmergencyActionCard(
                  title: localizations.heartAttack,
                  subtitle: localizations.heartAttackDesc,
                  icon: Icons.favorite,
                  onTap:
                      () => _showEmergencyModal(
                        context,
                        localizations.heartAttack,
                        localizations.heartAttackInstructions,
                      ),
                ),
                EmergencyActionCard(
                  title: localizations.stroke,
                  subtitle: localizations.strokeDesc,
                  icon: Icons.psychology,
                  onTap:
                      () => _showEmergencyModal(
                        context,
                        localizations.stroke,
                        localizations.strokeInstructions,
                      ),
                ),
                const SizedBox(height: 20), // Spasi akhir list
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fungsi untuk menampilkan modal bottom sheet berisi detail petunjuk pertolongan
  void _showEmergencyModal(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // agar modal bisa di-drag
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9, // Ukuran awal modal saat muncul
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder:
              (_, controller) => Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    /// Header modal berisi judul dan tombol tutup
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFE53E3E), Color(0xFFD53F8C)],
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),

                    /// Isi konten dengan scroll
                    Expanded(
                      child: ListView(
                        controller: controller,
                        padding: const EdgeInsets.all(20),
                        children: _buildFormattedContent(content),
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }

  /// Fungsi untuk membentuk isi konten menjadi bagian info dan langkah-langkah terstruktur
  List<Widget> _buildFormattedContent(String content) {
    List<Widget> widgets = [];

    // Pisahkan antara bagian penjelasan dan langkah-langkah
    List<String> parts = content.split(RegExp(r'(Langkah:|Steps:)'));

    if (parts.length > 1) {
      // Tambahkan bagian penjelasan sebelum langkah-langkah jika ada
      if (parts[0].trim().isNotEmpty) {
        widgets.add(
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0F2FE)),
            ),
            child: Text(
              parts[0].trim(),
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }

      // Ambil konten langkah-langkah dan pisahkan tiap langkah berdasarkan huruf (a. b. c.)
      String stepsContent = parts[1];
      List<String> steps =
          stepsContent
              .split(RegExp(r'\n[a-f]\.\s*'))
              .where((step) => step.trim().isNotEmpty)
              .toList();

      if (steps.isNotEmpty) {
        widgets.add(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Text(
              'Langkah-langkah:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        );

        // Tampilkan setiap langkah dalam bentuk kartu bernomor
        for (int i = 0; i < steps.length; i++) {
          String step = steps[i].trim();
          step = step.replaceFirst(
            RegExp(r'^[a-f]\.\s*'),
            '',
          ); // Hapus awalan huruf jika ada

          widgets.add(
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Nomor langkah
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDC2626),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  /// Isi teks langkah
                  Expanded(
                    child: Text(
                      step,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    } else {
      // Jika konten tidak memiliki langkah-langkah, tampilkan sebagai satu blok teks
      widgets.add(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Color(0xFF334155),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}
