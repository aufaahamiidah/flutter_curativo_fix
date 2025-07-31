import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart'; // Localization untuk mendukung multi-bahasa
import 'package:flutter_curativo/screens/main_tab_view.dart'; // Halaman utama setelah login
import '/screens/register_screen.dart'; // Halaman register
import 'package:flutter_curativo/services/auth_service.dart'; // Service untuk autentikasi
import '/widgets/common/generic_button.dart'; // Widget tombol custom
import '/widgets/common/custom_text_field.dart'; // Widget input custom

// LoginPage menggunakan StatefulWidget karena memerlukan state (email, password, loading)
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk menangani input dari pengguna
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State untuk menandai apakah sedang memproses login
  bool _isLoading = false;

  // Membersihkan controller ketika halaman dihancurkan untuk menghindari memory leak
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan snackbar (notifikasi bawah)
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: _isLoading ? Colors.blueGrey : Colors.red,
        ),
      );
    }
  }

  // Fungsi utama untuk login pengguna
  Future<void> _login() async {
    final localizations = AppLocalizations.of(context)!;
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // Validasi input kosong
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(localizations.emailPasswordRequired);
      return;
    }

    // Tampilkan loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService(); // Inisialisasi service autentikasi
      final result = await authService.login(
        email,
        password,
      ); // Kirim request login

      if (!mounted) return; // Hindari update jika widget sudah tidak aktif

      if (result['success']) {
        // Jika login sukses, navigasi ke halaman utama dan hapus riwayat back
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainTabView()),
          (Route<dynamic> route) => false,
        );
      } else {
        // Jika login gagal, tampilkan pesan error
        _showSnackBar(result['message'] ?? localizations.loginFailed);
      }
    } catch (e) {
      // Tangani jika terjadi error saat request
      if (mounted) {
        _showSnackBar('${localizations.errorOccurred}: ${e.toString()}');
      }
    } finally {
      // Sembunyikan loading indicator
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations =
        AppLocalizations.of(context)!; // Ambil teks sesuai bahasa yang dipilih

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          // Supaya tampilan bisa di-scroll saat keyboard muncul
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo atau branding aplikasi
              Image.asset(
                'assets/images/Curativo.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 24),

              // Judul halaman login
              Text(
                localizations.loginTitle, // Misal: "Masuk"
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 40),

              // Input email
              CustomTextField(
                controller: _emailController,
                hintText:
                    localizations.enterEmail, // Placeholder dari localization
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Input password
              CustomTextField(
                controller: _passwordController,
                hintText: localizations.enterPassword,
                icon: Icons.lock_outline,
                isPassword: true, // Menyembunyikan teks ketika diketik
              ),
              const SizedBox(height: 32),

              // Tombol login
              SizedBox(
                width: double.infinity,
                child: GenericButton(
                  text:
                      _isLoading ? localizations.loading : localizations.login,
                  onPressed:
                      _isLoading
                          ? () {}
                          : () => _login(), // Disable saat loading
                  type: ButtonType.elevated,
                  backgroundColor: const Color(0xFF000080), // Biru gelap
                  textColor: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const SizedBox(height: 24),

              // Navigasi ke halaman register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.dontHaveAccount,
                  ), // Teks "Belum punya akun?"
                  const SizedBox(width: 8),
                  GenericButton(
                    text: localizations.registerTitle, // Teks "Daftar"
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    type: ButtonType.text,
                    textColor: const Color(0xFF000080), // Warna teks biru
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
