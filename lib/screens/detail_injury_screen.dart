import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailScreen({super.key, required this.data});

  String formatTanggal(String isoDateString) {
    try {
      final dateTime = DateTime.parse(isoDateString).toLocal();
      final hari = DateFormat('EEEE', 'id_ID').format(dateTime);
      final tanggal = DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(dateTime);
      return '$hari, $tanggal';
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    final detectedAt = data['detected_at'] ?? '';
    final label = data['label'] ?? '-';
    final recommendation = data['recommendation'] ?? '-';
    final imageUrl = data['image'];

    final rawScore = data['scores'];
    final doubleScore =
        rawScore is double
            ? rawScore
            : double.tryParse(rawScore.toString()) ?? 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Luka')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Gagal memuat gambar', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Tidak ada gambar', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Text('Jenis Luka:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              'Tingkat Keyakinan:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              '${(doubleScore * 100).toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Tanggal Deteksi:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              formatTanggal(detectedAt),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Rekomendasi:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(recommendation, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
