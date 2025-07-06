import 'package:flutter/material.dart';
import '/widgets/custom_bottom_navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header image
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/header.png', // ilustrasi header (obat-obatan)
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: -40,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.png'), // foto profil
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            // Nama username
            const Text(
              'gyu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Informasi user
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: const [
                  InfoTile(title: 'Nama Lengkap', value: 'Gyu'),
                  InfoTile(title: 'Jenis kelamin', value: 'Laki-laki'),
                  InfoTile(title: 'Tanggal Lahir', value: '6 April 1997'),
                  InfoTile(title: 'Email', value: 'igyu@gmail.com'),
                  InfoTile(title: 'No. Telepon', value: '08123456789'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tombol Edit Profile dan Tentang Aplikasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  OptionButton(text: 'Edit Profile'),
                  const SizedBox(height: 10),
                  OptionButton(text: 'Tentang Aplikasi'),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Aksi logout
              },
              child: const Text(
                'LOGOUT',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;

  const OptionButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Aksi ketika tombol ditekan
        },
      ),
    );
  }
}
