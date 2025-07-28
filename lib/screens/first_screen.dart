import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import '/screens/login_screen.dart';
import '/screens/register_screen.dart';
import '/widgets/common/generic_button.dart';
import '../widgets/common/language_switcher.dart';

class LandingPage extends StatelessWidget {
  final Function(Locale)? onLanguageChanged;
  
  const LandingPage({super.key, this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/first_screen.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          // Tambahkan language switcher jika diperlukan
          if (onLanguageChanged != null)
            Positioned(
              top: 50,
              right: 20,
              child: LanguageSwitcher(
                onLanguageChanged: onLanguageChanged!,
              ),
            ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    localizations.welcome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 150),
                  SizedBox(
                    width: double.infinity,
                    child: GenericButton(
                      text: localizations.login,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
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
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: GenericButton(
                      text: localizations.register,
                      onPressed: () {
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
