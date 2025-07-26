import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/emergency_header.dart';
import '../widgets/emergency_contact_card.dart';
import '../widgets/emergency_action_card.dart';
import '../widgets/section_header.dart';

class AidScreen extends StatefulWidget {
  const AidScreen({super.key});

  @override
  State<AidScreen> createState() => _AidScreenState();
}

class _AidScreenState extends State<AidScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          EmergencyHeader(
            title: 'Berikan Bantuan',
            subtitle: 'Panduan pertolongan pertama darurat',
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
          const EmergencyContactCard(
            title: 'Kontak Darurat 112',
            subtitle: 'Hubungi layanan darurat Indonesia',
            phoneNumber: '112',
            icon: FeatherIcons.phone,
          ),
          const SizedBox(height: 24),
          const SectionHeader(
            title: 'Panduan Darurat',
            subtitle: 'Langkah-langkah pertolongan pertama',
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                EmergencyActionCard(
                  title: 'Tersedak (Dewasa, Lansia)',
                  subtitle: 'Heimlich maneuver untuk dewasa',
                  icon: Icons.person,
                  onTap: () => _showEmergencyModal(
                    context,
                    'Tersedak (Dewasa, Lansia)',
                    'Jika seseorang dewasa atau lansia tersedak dan masih bisa batuk atau bersuara, biarkan mereka batuk untuk mencoba mengeluarkan objek tersebut. Jika tidak bisa bernapas atau bicara, lakukan Heimlich maneuver.',
                  ),
                ),
                EmergencyActionCard(
                  title: 'Tersedak (Anak Kecil)',
                  subtitle: 'Teknik khusus untuk anak-anak',
                  icon: Icons.child_care,
                  onTap: () => _showEmergencyModal(
                    context,
                    'Tersedak (Anak Kecil)',
                    'Untuk anak kecil, posisikan mereka membungkuk ke depan dan tepuk punggung mereka lima kali dengan telapak tangan. Jika tidak berhasil, lakukan dorongan perut.',
                  ),
                ),
                EmergencyActionCard(
                  title: 'Tersedak (Bayi)',
                  subtitle: 'Penanganan khusus untuk bayi',
                  icon: Icons.baby_changing_station,
                  onTap: () => _showEmergencyModal(
                    context,
                    'Tersedak (Bayi)',
                    'Letakkan bayi telungkup di lengan Anda, kepala lebih rendah dari tubuh. Berikan lima tepukan di punggung, lalu lima tekanan dada jika belum berhasil.',
                  ),
                ),
                EmergencyActionCard(
                  title: 'Pendarahan Parah',
                  subtitle: 'Cara menghentikan pendarahan',
                  icon: Icons.bloodtype,
                  onTap: () => _showEmergencyModal(
                    context,
                    'Pendarahan Parah',
                    'Tekan langsung pada luka dengan kain bersih atau perban. Jika darah menembus, tambahkan lapisan lain tanpa melepas yang pertama. Angkat bagian yang berdarah lebih tinggi dari jantung jika memungkinkan.',
                  ),
                ),
                EmergencyActionCard(
                  title: 'Serangan Jantung',
                  subtitle: 'Tanda dan penanganan darurat',
                  icon: Icons.favorite,
                  onTap: () => _showEmergencyModal(
                    context,
                    'Serangan Jantung',
                    'Panggil bantuan medis segera. Berikan aspirin jika tersedia dan korban tidak alergi. Posisikan korban duduk dengan nyaman, longgarkan pakaian ketat.',
                  ),
                ),
                EmergencyActionCard(
                  title: 'Stroke',
                  subtitle: 'Deteksi dini dan penanganan',
                  icon: Icons.psychology,
                  onTap: () => _showEmergencyModal(
                    context,
                    'Stroke',
                    'Gunakan tes FAST: Face (wajah), Arms (lengan), Speech (bicara), Time (waktu). Jika ada tanda stroke, segera hubungi layanan darurat.',
                  ),
                ),
                EmergencyActionCard(
                  title: 'Luka Bakar',
                  subtitle: 'Penanganan luka bakar ringan hingga berat',
                  icon: Icons.local_fire_department,
                  onTap: () => _showEmergencyModal(
                    context,
                    'Luka Bakar',
                    'Dinginkan luka bakar dengan air mengalir selama 10-20 menit. Jangan gunakan es. Tutup dengan kain bersih yang lembab. Untuk luka bakar parah, segera cari bantuan medis.',
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
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE53E3E),
                        Color(0xFFD53F8C),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
