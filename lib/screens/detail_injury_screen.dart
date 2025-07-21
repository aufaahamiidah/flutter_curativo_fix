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
    final scores = data['scores']?.toStringAsFixed(2) ?? '-';
    final imageUrl = data['image'];

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
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 100),
                  ),
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
            Text('$scores%', style: const TextStyle(fontSize: 16)),
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
