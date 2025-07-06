import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String result;
  final String rekomendasi;

  const ResultScreen({
    super.key,
    required this.result,
    required this.rekomendasi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Kembali ke ScanScreen
          },
        ),
        title: const Text('Hasil Deteksi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deteksi:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(result, style: TextStyle(fontSize: 18)),

            const SizedBox(height: 20),
            Text(
              'Rekomendasi:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(rekomendasi, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
