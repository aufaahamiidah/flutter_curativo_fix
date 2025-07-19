import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/injury_services.dart';

class ResultScreen extends StatefulWidget {
  final String result;
  final List<String> rekomendasi;
  final double score;
  final File? imageFile;
  final List<Rect>? boundingBoxes;

  const ResultScreen({
    super.key,
    required this.result,
    required this.rekomendasi,
    required this.score,
    this.imageFile,
    this.boundingBoxes,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveHistory();
  }

  Future<void> _saveHistory() async {
    try {
      String? base64Image;

      if (widget.imageFile != null) {
        final bytes = await widget.imageFile!.readAsBytes();
        base64Image = base64Encode(bytes);
      }

      await InjuryHistoryService().addInjuryHistory(
        label: widget.result,
        recommendation:
            widget.rekomendasi.isNotEmpty
                ? widget.rekomendasi.join(', ')
                : null,
        detectedAt: DateTime.now(),
        scores: widget.score,
        image: base64Image,
      );
    } catch (e) {
      print('❌ Gagal menyimpan riwayat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Deteksi'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.imageFile != null) ...[
              SizedBox(
                width: double.infinity,
                height: 300, // Sesuaikan tinggi jika perlu
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(widget.imageFile!, fit: BoxFit.cover),
                    if (widget.boundingBoxes != null)
                      ...widget.boundingBoxes!.map(
                        (box) => Positioned(
                          left: box.left,
                          top: box.top,
                          width: box.width,
                          height: box.height,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Hasil Deteksi
            const Text(
              'Deteksi:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.result, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),

            // Skor Keyakinan
            const Text(
              'Tingkat Keyakinan:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${(widget.score * 100).toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Rekomendasi
            const Text(
              'Rekomendasi:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (widget.rekomendasi.isEmpty)
              const Text(
                '- Tidak ada rekomendasi',
                style: TextStyle(fontSize: 16),
              )
            else
              ...widget.rekomendasi.map(
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
