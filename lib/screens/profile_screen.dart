import 'package:flutter/material.dart';
import 'package:flutter_curativo/screens/first_screen.dart';
// import '/widgets/custom_bottom_navbar.dart';
import '/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final result = await ProfileService().getProfile();
    print('Profile result: $result');
    if (mounted) {
      setState(() {
        user = result['user'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                            backgroundImage: AssetImage(
                              'assets/images/profile.png',
                            ), // foto profil
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    // Nama username
                    Text(
                      user?['name'] ?? '-',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Informasi user
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        // HAPUS kata kunci 'const' di sini!
                        children: [
                          InfoTile(
                            title: 'Nama Lengkap',
                            value: user?['name'] ?? '-',
                          ),
                          InfoTile(
                            title: 'Jenis kelamin',
                            value: user?['jenis_kelamin'] ?? '-',
                          ),
                          InfoTile(
                            title: 'Email',
                            value: user?['email'] ?? '-',
                          ),
                          InfoTile(
                            title: 'No. Telepon',
                            value: user?['no_telp'] ?? '-',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tombol Edit Profile dan Tentang Aplikasi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear(); // hapus token / data user

                        // Navigasi ke FirstScreen dan hapus semua stack sebelumnya
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LandingPage(),
                          ),
                          (route) => false,
                        );
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
      // bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
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
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
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
