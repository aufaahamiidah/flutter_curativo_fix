import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import '/screens/login_screen.dart';
import '/screens/register_screen.dart';
import '/widgets/common/generic_button.dart';
import '../widgets/common/language_switcher.dart';

/// Halaman awal aplikasi yang menampilkan tombol login & register
/// serta switcher bahasa jika disediakan
class LandingPage extends StatelessWidget {
  // Callback opsional untuk mengganti bahasa (locale)
  final Function(Locale)? onLanguageChanged;

  const LandingPage({super.key, this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan teks lokal berdasarkan bahasa yang dipilih
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Background gambar layar pertama
          Positioned.fill(
            child: Image.asset(
              'assets/images/first_screen.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Lapisan hitam semi-transparan di atas gambar
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // Language Switcher muncul hanya jika properti onLanguageChanged diberikan
          if (onLanguageChanged != null)
            Positioned(
              top: 50,
              right: 20,
              child: LanguageSwitcher(onLanguageChanged: onLanguageChanged!),
            ),

          // Konten utama (tengah layar)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Posisi di bawah layar
                children: [
                  const SizedBox(
                    height: 40,
                  ), // Spasi atas untuk icon/logo (opsional)
                  // Teks sambutan "Selamat Datang" atau "Welcome"
                  Text(
                    localizations.welcome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 150), // Spasi antara teks dan tombol
                  // Tombol Login (gunakan GenericButton kustom)
                  SizedBox(
                    width: double.infinity,
                    child: GenericButton(
                      text: localizations.login,
                      onPressed: () {
                        // Navigasi ke halaman Login
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      type: ButtonType.elevated,
                      backgroundColor: const Color(0xFF000080), // Biru navy
                      textColor: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol Register (Outlined style)
                  SizedBox(
                    width: double.infinity,
                    child: GenericButton(
                      text: localizations.register,
                      onPressed: () {
                        // Navigasi ke halaman Register
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      type: ButtonType.outlined,
                      textColor: Colors.white,
                      borderColor: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),

                  const SizedBox(height: 40), // Spasi bawah
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
