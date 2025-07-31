import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart'; // Paket lokal untuk mendukung multibahasa
import 'package:feather_icons/feather_icons.dart'; // Paket ikon Feather
import '../widgets/emergency/emergency_header.dart'; // Widget header darurat
import '../widgets/emergency/emergency_contact_card.dart'; // Kartu kontak darurat
import '../widgets/emergency/emergency_action_card.dart'; // Kartu tindakan darurat
import '../widgets/headers/section_header.dart'; // Header seksi umum

// Widget Stateful untuk halaman pertolongan pertama
class AidScreen extends StatefulWidget {
  const AidScreen({super.key});

  @override
  State<AidScreen> createState() => _AidScreenState();
}

class _AidScreenState extends State<AidScreen> {
  @override
  Widget build(BuildContext context) {
    // Ambil teks berdasarkan lokal/bahasa yang sedang aktif
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Warna latar belakang
      body: Column(
        children: [
          // Header darurat dengan judul dan ikon
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

          // Kartu kontak untuk nomor darurat 112
          EmergencyContactCard(
            title: localizations.emergencyContact112,
            subtitle: localizations.emergencyContactDesc,
            phoneNumber: '112',
            icon: FeatherIcons.phone,
          ),

          const SizedBox(height: 24),

          // Header seksi untuk panduan tindakan darurat
          SectionHeader(
            title: localizations.emergencyGuide,
            subtitle: localizations.emergencySteps,
          ),

          const SizedBox(height: 8),

          // Daftar kartu tindakan darurat
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                // Kartu tindakan: Tersedak orang dewasa
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
                // Kartu tindakan: Tersedak anak
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
                // Kartu tindakan: Tersedak bayi
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
                // Kartu tindakan: Pendarahan parah
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
                // Kartu tindakan: Serangan jantung
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
                // Kartu tindakan: Stroke
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
                // Kartu tindakan: Luka bakar
                EmergencyActionCard(
                  title: localizations.burns,
                  subtitle: localizations.burnsDesc,
                  icon: Icons.local_fire_department,
                  onTap:
                      () => _showEmergencyModal(
                        context,
                        localizations.burns,
                        localizations.burnsInstructions,
                      ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan modal bottom sheet saat salah satu tindakan darurat ditekan
  void _showEmergencyModal(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9, // Ukuran awal modal
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
                    // Header modal dengan judul dan tombol tutup
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
                            onPressed:
                                () =>
                                    Navigator.of(context).pop(), // Tutup modal
                          ),
                        ],
                      ),
                    ),
                    // Isi konten petunjuk
                    Expanded(
                      child: ListView(
                        controller: controller,
                        padding: const EdgeInsets.all(20),
                        children: [
                          Text(
                            content,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
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
