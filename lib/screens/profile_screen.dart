import 'package:flutter/material.dart';
import '/services/profile_service.dart'; // Service untuk mengambil data profil dari backend
import 'package:flutter_curativo/widgets/headers/profile_header.dart'; // Header tampilan profil
import 'package:flutter_curativo/widgets/cards/personal_info_card.dart'; // Kartu info pribadi
import 'package:flutter_curativo/widgets/cards/profile_menu_card.dart'; // Menu pilihan di profil
import 'package:flutter_curativo/widgets/profile/logout_button.dart'; // Tombol logout
import 'package:shared_preferences/shared_preferences.dart'; // Untuk menyimpan preferensi (seperti bahasa)

// Halaman Profil pengguna
class ProfileScreen extends StatefulWidget {
  final Function(Locale)? onLanguageChanged; // Callback untuk mengganti bahasa

  const ProfileScreen({super.key, this.onLanguageChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user; // Data user yang diambil dari API
  bool isLoading = true; // Status loading saat data belum diambil
  String _currentLanguage = 'id'; // Bahasa default

  @override
  void initState() {
    super.initState();
    fetchProfile(); // Panggil API profil saat pertama load
    _loadLanguage(); // Ambil preferensi bahasa dari penyimpanan lokal
  }

  // Fungsi untuk mengambil preferensi bahasa yang tersimpan
  _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguage = prefs.getString('language') ?? 'id';
    });
  }

  // Fungsi untuk menyimpan pilihan bahasa
  _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  // Fungsi untuk mengambil data profil dari server
  Future<void> fetchProfile() async {
    final result = await ProfileService().getProfile();

    // Pastikan widget masih hidup sebelum mengubah state
    if (mounted) {
      setState(() {
        user = result['user'];
        isLoading = false;
      });
    }
  }

  // Fungsi pembantu untuk menghasilkan warna acak berdasarkan nama pengguna
  Color getRandomColor(String? input) {
    if (input == null) return Colors.grey;
    final hash = input.codeUnits.fold(0, (prev, elem) => prev + elem);
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.indigo,
      Colors.deepOrange,
      Colors.pink,
    ];
    return colors[hash % colors.length];
  }

  // Fungsi untuk mendapatkan inisial dari nama user (contoh: "Budi Santoso" -> "BS")
  String getInitials(String? name) {
    if (name == null || name.isEmpty) return "?";
    List<String> parts = name.trim().split(" ");
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // Widget toggle bahasa di pojok kanan atas
  Widget _buildLanguageToggle() {
    return Positioned(
      top: 50,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tombol bahasa individual (id/en)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Warna latar belakang
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Tampilkan loading saat data belum ada
              : Stack(
                children: [
                  RefreshIndicator(
                    onRefresh:
                        fetchProfile, // Tarik ke bawah untuk memuat ulang
                    color: const Color(0xFF000080),
                    backgroundColor: Colors.white,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Header profil (nama, inisial, avatar)
                          ProfileHeader(
                            user: user,
                            getRandomColor: getRandomColor,
                            getInitials: getInitials,
                          ),
                          const SizedBox(height: 30),

                          // Informasi pribadi user
                          PersonalInfoCard(user: user),
                          const SizedBox(height: 20),

                          // Menu pengaturan profil lainnya
                          ProfileMenuCard(onLanguageChanged: null),
                          const SizedBox(height: 30),

                          // Tombol logout dari aplikasi
                          const LogoutButton(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),

                  // Tombol toggle bahasa
                  _buildLanguageToggle(),
                ],
              ),
    );
  }
}

// Komponen kecil untuk menampilkan info seperti email, nomor telepon, dsb
class InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Icon dengan latar berwarna
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),

          // Teks title dan value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Tombol menu dalam bentuk list (misalnya untuk logout, ubah password, dll)
class OptionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const OptionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFE53E3E), size: 24),
        title: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF999999),
        ),
        onTap: onTap, // Eksekusi fungsi saat ditekan
      ),
    );
  }
}
