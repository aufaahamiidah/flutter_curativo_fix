import 'package:flutter/material.dart';
import 'package:flutter_curativo/screens/about_screen.dart';
import '../common/option_button.dart';

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            OptionButton(
              icon: Icons.info_outline,
              text: 'Tentang Aplikasi',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutAppScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}