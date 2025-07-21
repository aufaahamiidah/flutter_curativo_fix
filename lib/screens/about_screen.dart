import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Aplikasi')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deteksi Luka v1.0.0',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Aplikasi ini digunakan untuk mendeteksi jenis luka pada tubuh menggunakan kamera dan AI.',
            ),
            SizedBox(height: 20),
            Text('Dikembangkan oleh GreenMonkey Team.'),
          ],
        ),
      ),
    );
  }
}
