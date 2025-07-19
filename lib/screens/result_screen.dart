import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String result;
  final List<String> rekomendasi;
  final double score;

  const ResultScreen({
    super.key,
    required this.result,
    required this.rekomendasi,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
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
            /// HASIL DETEKSI
            Text(
              'Deteksi:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(result, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            /// SCORE
            Text(
              'Tingkat Keyakinan:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${(score * 100).toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            /// REKOMENDASI
            Text(
              'Rekomendasi:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (rekomendasi.isEmpty)
              const Text(
                '- Tidak ada rekomendasi',
                style: TextStyle(fontSize: 16),
              )
            else
              ...rekomendasi.map(
                (point) => Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
