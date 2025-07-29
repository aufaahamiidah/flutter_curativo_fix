import 'package:flutter/material.dart';
import 'package:flutter_curativo/screens/main_tab_view.dart';
import 'package:flutter_curativo/services/auth_service.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import '/screens/login_screen.dart';
import '/widgets/common/generic_button.dart';
import '/widgets/common/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk menangani input pengguna pada masing-masing field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Variabel untuk menyimpan jenis kelamin yang dipilih
  String? _selectedGender;

  // Membersihkan controller saat widget dihapus dari tree
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan snackbar pesan kesalahan atau informasi
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil instance lokal dari AppLocalizations untuk mendukung multi-bahasa
    final localizations = AppLocalizations.of(context)!;

    // Opsi gender ditampilkan dalam dropdown
    final genderOptions = [localizations.male, localizations.female];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo aplikasi
              Image.asset(
                'assets/images/Curativo.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 24),

              // Judul halaman registrasi
              Text(
                localizations.registerTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 40),

              // Field input nama lengkap
              CustomTextField(
                controller: _nameController,
                hintText: localizations.enterFullName,
                icon: Icons.person_outline,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              // Dropdown untuk memilih jenis kelamin
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: const Color(0xFFCCCCCC)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  hint: Text(
                    localizations.selectGender,
                    style: const TextStyle(color: Color(0xFFA0A0A0)),
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
                      genderOptions.map((String gender) {
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

              // Field input nomor telepon
              CustomTextField(
                controller: _phoneNumberController,
                hintText: localizations.enterPhoneNumber,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // Field input email
              CustomTextField(
                controller: _emailController,
                hintText: localizations.enterEmail,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Field input password
              CustomTextField(
                controller: _passwordController,
                hintText: localizations.enterPassword,
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),

              // Field konfirmasi password
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: localizations.confirmPassword,
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 32),

              // Tombol daftar/register
              SizedBox(
                width: double.infinity,
                child: GenericButton(
                  text: localizations.register,
                  onPressed: () async {
                    // Ambil nilai dari form
                    String name = _nameController.text.trim();
                    String email = _emailController.text.trim();
                    String phoneNumber = _phoneNumberController.text.trim();
                    String password = _passwordController.text.trim();
                    String confirmPassword =
                        _confirmPasswordController.text.trim();
                    String? gender = _selectedGender;

                    // Validasi input wajib
                    if (name.isEmpty ||
                        email.isEmpty ||
                        phoneNumber.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty ||
                        gender == null) {
                      _showSnackBar(localizations.allFieldsRequired);
                      return;
                    }

                    // Validasi password cocok
                    if (password != confirmPassword) {
                      _showSnackBar(localizations.passwordMismatch);
                      return;
                    }

                    // Kirim data ke backend menggunakan AuthService
                    final auth = AuthService();
                    final result = await auth.registerWithDetails(
                      name: name,
                      email: email,
                      password: password,
                      confirmPassword: confirmPassword,
                      phone: phoneNumber,
                      gender: gender,
                    );

                    // Jika berhasil, navigasi ke halaman utama
                    if (result['success']) {
                      _showSnackBar(localizations.registrationSuccess);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const MainTabView(),
                        ),
                        (route) => false,
                      );
                    } else {
                      // Jika gagal, tampilkan pesan error
                      _showSnackBar(
                        result['message'] ?? localizations.registrationFailed,
                      );
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

              // Link ke halaman login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizations.alreadyHaveAccount,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                  GenericButton(
                    text: localizations.login,
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
