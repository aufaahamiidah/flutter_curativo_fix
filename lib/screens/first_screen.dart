import 'package:flutter/material.dart';
import '/screens/login_screen.dart'; 
import '/screens/register_screen.dart'; 
import '/widgets/generic_button.dart'; 

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              color: Colors.black.withOpacity(0.4), 
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Posisikan tombol di bagian bawah
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Selamat Datang di Curativo',
                    style: TextStyle(
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
                      text: 'MASUK',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
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
                      text: 'DAFTAR',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
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
