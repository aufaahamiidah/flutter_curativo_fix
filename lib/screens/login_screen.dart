import 'package:flutter/material.dart';
import '/screens/register_screen.dart'; 
import '/screens/home_screen.dart'; 
import '/widgets/generic_button.dart'; 
import '/widgets/custom_text_field.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                          side: const BorderSide(color: Colors.grey, width: 1.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Ingat saya',
                        style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                      ),
                    ],
                  ),
                  TextButton( 
                    onPressed: () {
                      _showSnackBar('Fungsionalitas lupa kata sandi belum diimplementasikan.');
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
                  text: 'MASUK',
                  onPressed: () {
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    if (email.isEmpty || password.isEmpty) {
                      _showSnackBar('Email dan password harus diisi.');
                      return;
                    }
                    _showSnackBar('Login berhasil! Menuju Home Screen.');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
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
