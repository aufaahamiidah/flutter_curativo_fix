import 'package:flutter/material.dart';

import 'package:flutter_curativo/services/auth_service.dart';
import '/screens/login_screen.dart';
import '/screens/home_screen.dart';
import '/widgets/generic_button.dart';
import '/widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedGender;
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan', 'Lainnya'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
                'Daftar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _nameController,
                hintText: 'Masukkan Nama Lengkap',
                icon: Icons.person_outline,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: const Color(0xFFCCCCCC)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  hint: const Text(
                    'Pilih Jenis Kelamin',
                    style: TextStyle(color: Color(0xFFA0A0A0)),
                  ),
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xFFA0A0A0),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.wc_outlined,
                      color: Color(0xFFA0A0A0),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  items:
                      _genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneNumberController,
                hintText: 'Masukkan Nomor Telepon',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
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
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Konfirmasi Password',
                icon: Icons.lock_outline,
                isPassword: true, // Set isPassword ke true
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: GenericButton(
                  text: 'DAFTAR',
                  onPressed: () async {
                    String name = _nameController.text.trim();
                    String email = _emailController.text.trim();
                    String phoneNumber = _phoneNumberController.text.trim();
                    String password = _passwordController.text.trim();
                    String confirmPassword =
                        _confirmPasswordController.text.trim();
                    String? gender = _selectedGender;

                    if (name.isEmpty ||
                        email.isEmpty ||
                        phoneNumber.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty ||
                        gender == null) {
                      _showSnackBar(
                        'Semua field harus diisi dan jenis kelamin harus dipilih.',
                      );
                      return;
                    }

                    if (password != confirmPassword) {
                      _showSnackBar('Konfirmasi password tidak cocok.');
                      return;
                    }

                    final auth = AuthService();
                    final result = await auth.registerWithDetails(
                      name: name,
                      email: email,
                      password: password,
                      confirmPassword: confirmPassword,
                      phone: phoneNumber,
                      gender: gender,
                    );

                    if (result['success']) {
                      _showSnackBar(
                        'Pendaftaran berhasil! Menuju Home Screen.',
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      _showSnackBar(result['message'] ?? 'Pendaftaran gagal.');
                    }
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
                    'Sudah punya akun?',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                  GenericButton(
                    text: 'Masuk',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
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
