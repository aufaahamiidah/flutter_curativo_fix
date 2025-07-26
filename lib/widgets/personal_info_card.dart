import 'package:flutter/material.dart';
import 'info_tile.dart';

class PersonalInfoCard extends StatelessWidget {
  final Map<String, dynamic>? user;

  const PersonalInfoCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF2196F3),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Informasi Personal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InfoTile(
              icon: Icons.badge,
              iconColor: const Color(0xFF2196F3),
              title: 'Nama Lengkap',
              value: user?['name'] ?? '-',
            ),
            InfoTile(
              icon: Icons.wc,
              iconColor: const Color(0xFF9C27B0),
              title: 'Jenis Kelamin',
              value: user?['jenis_kelamin'] ?? '-',
            ),
            InfoTile(
              icon: Icons.email,
              iconColor: const Color(0xFF4CAF50),
              title: 'Email',
              value: user?['email'] ?? '-',
            ),
            InfoTile(
              icon: Icons.phone,
              iconColor: const Color(0xFFFF9800),
              title: 'No. Telepon',
              value: user?['no_telp'] ?? '-',
            ),
          ],
        ),
      ),
    );
  }
}