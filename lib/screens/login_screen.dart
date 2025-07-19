import 'package:flutter/material.dart';
import '/screens/register_screen.dart';
import '/screens/home_screen.dart';
// import '/screens/forgot_password_screen.dart'; // Anda mungkin perlu membuat halaman ini
import '/widgets/generic_button.dart';
import '/widgets/custom_text_field.dart';
import 'package:flutter_curativo/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State untuk checkbox dan loading indicator
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan SnackBar dengan lebih aman
  void _showSnackBar(String message) {
    // Pastikan widget masih terpasang sebelum menampilkan SnackBar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: _isLoading ? Colors.blueGrey : Colors.red,
        ),
      );
    }
  }

  // Fungsi utama untuk menangani proses login
  Future<void> _login() async {
    // Validasi input
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email dan password harus diisi.');
      return;
    }

    // Mulai loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // Panggil service untuk otentikasi
      final authService = AuthService();
      final result = await authService.login(email, password);

      // Pastikan widget masih ada di tree sebelum navigasi atau menampilkan SnackBar
      if (!mounted) return;

      if (result['success']) {
        // Jika berhasil, navigasi ke HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Jika gagal, tampilkan pesan error dari service
        _showSnackBar(
          result['message'] ??
              'Login gagal. Periksa kembali email dan password Anda.',
        );
      }
    } catch (e) {
      // Tangani error yang tidak terduga
      if (mounted) {
        _showSnackBar('Terjadi kesalahan: ${e.toString()}');
      }
    } finally {
      // Hentikan loading indicator setelah proses selesai (baik berhasil maupun gagal)
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Curativo.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 24),
              const Text(
                'Masuk',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _emailController,
                hintText: 'Masukkan email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Masukkan Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF000080),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Ingat saya',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      _showSnackBar('Fitur Lupa Kata Sandi belum diimplementasikan.');
                    },
                    child: const Text(
                      'Lupa kata sandi?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF000080),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: GenericButton(
                  text: _isLoading ? 'Loading...' : 'MASUK',
                  onPressed: _isLoading ? () {} : _login,
                  type: ButtonType.elevated,
                  backgroundColor: const Color(0xFF000080),
                  textColor: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun?',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                  GenericButton(
                    text: 'Daftar',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    type: ButtonType.text,
                    textColor: const Color(0xFF000080),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.zero,
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
