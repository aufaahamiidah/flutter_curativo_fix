import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import 'package:flutter_curativo/screens/main_tab_view.dart';
import '/screens/register_screen.dart';
import 'package:flutter_curativo/services/auth_service.dart';
import '/widgets/common/generic_button.dart';
import '/widgets/common/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  Future<void> _login() async {
    final localizations = AppLocalizations.of(context)!;
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(localizations.emailPasswordRequired);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      final result = await authService.login(email, password);

      if (!mounted) return;

      if (result['success']) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainTabView()),
          (Route<dynamic> route) => false,
        );
      } else {
        _showSnackBar(
          result['message'] ?? localizations.loginFailed,
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('${localizations.errorOccurred}: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
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
              Text(
                localizations.loginTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _emailController,
                hintText: localizations.enterEmail,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                hintText: localizations.enterPassword,
                icon: Icons.lock_outline,
                isPassword: true,  // ✅ Gunakan parameter yang benar
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: GenericButton(
                  text: _isLoading ? localizations.loading : localizations.login,
                  onPressed: _isLoading ? () {} : () => _login(), // ✅ Wrap dengan anonymous function
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
                  Text(localizations.dontHaveAccount),
                  const SizedBox(width: 8),
                  GenericButton(
                    text: localizations.registerTitle,
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
