import 'package:flutter/material.dart';
import 'package:flutter_curativo/screens/main_tab_view.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '/screens/home_screen.dart';
import '/screens/first_screen.dart';
import 'package:flutter_curativo/services/auth_service.dart';

/// SplashScreen digunakan untuk menampilkan logo/animasi awal saat aplikasi pertama kali dibuka,
/// sekaligus mengecek status login pengguna dan mengarahkan ke halaman yang sesuai.
class SplashScreen extends StatefulWidget {
  final Function(Locale)? onLanguageChanged; // Callback untuk mengganti bahasa aplikasi
  
  const SplashScreen({super.key, this.onLanguageChanged});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Jalankan pengecekan login saat splash muncul
  }

  /// Fungsi ini menunggu 2 detik, lalu memeriksa apakah pengguna sudah login atau belum.
  /// Setelah itu, navigasi diarahkan ke halaman utama atau halaman landing.
  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Waktu delay splash
    final authService = AuthService();
    final loggedIn = await authService.isLoggedIn(); // Cek status login dari AuthService

    if (!mounted) return; // Pastikan widget masih dalam tree sebelum navigasi

    // Arahkan ke halaman yang sesuai (login atau home)
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => loggedIn 
            ? MainTabView(onLanguageChanged: widget.onLanguageChanged) 
            : LandingPage(onLanguageChanged: widget.onLanguageChanged),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Warna latar belakang putih
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/curativo_splash.png', // Logo aplikasi
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
