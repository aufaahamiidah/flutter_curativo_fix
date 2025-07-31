import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import '../lists/info_tile.dart';

class PersonalInfoCard extends StatelessWidget {
  final Map<String, dynamic>? user;

  const PersonalInfoCard({super.key, this.user});

  // Fungsi untuk mentranslasi jenis kelamin
  String translateGender(String? gender, AppLocalizations localizations) {
    if (gender == null || gender == '-') return '-';
    
    // Translasi dari Indonesia ke bahasa yang sesuai
    switch (gender.toLowerCase()) {
      case 'laki-laki':
        return localizations.male;
      case 'perempuan':
        return localizations.female;
      default:
        return gender; // Kembalikan nilai asli jika tidak dikenali
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.personalInformation,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          InfoTile(
            icon: Icons.person,
            iconColor: const Color(0xFF2196F3),
            title: localizations.fullName,
            value: user?['name'] ?? '-', // Ubah dari 'nama_lengkap' ke 'name'
          ),
          InfoTile(
            icon: Icons.wc,
            iconColor: const Color(0xFF9C27B0),
            title: localizations.gender,
            value: translateGender(user?['jenis_kelamin'], localizations),
          ),
          InfoTile(
            icon: Icons.email,
            iconColor: const Color(0xFF4CAF50),
            title: localizations.email,
            value: user?['email'] ?? '-',
          ),
          InfoTile(
            icon: Icons.phone,
            iconColor: const Color(0xFFFF9800),
            title: localizations.phoneNumber,
            value: user?['no_telp'] ?? '-',
          ),
        ],
      ),
    );
  }
}