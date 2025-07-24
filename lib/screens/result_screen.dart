import 'dart:io';
import 'package:flutter/material.dart';
import '../services/injury_services.dart';

class ResultScreen extends StatefulWidget {
  final String result;
  final List<String> rekomendasi;
  final double score;
  final File imageFile;
  final Rect? boxRect;
  final int originalWidth;
  final int originalHeight;

  const ResultScreen({
    super.key,
    required this.result,
    required this.rekomendasi,
    required this.score,
    required this.imageFile,
    required this.boxRect,
    required this.originalWidth,
    required this.originalHeight,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaving = false;

  Future<void> _saveHistory() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Gunakan fungsi baru yang mendukung upload gambar WebP ke Supabase
      await InjuryHistoryService().addInjuryHistoryWithImage(
        label: widget.result,
        imageFile: widget.imageFile, // Akan dikonversi ke WebP di service
        recommendation: widget.rekomendasi.join(', '),
        detectedAt: DateTime.now(),
        scores: widget.score,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Riwayat berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('❌ Gagal menyimpan riwayat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan riwayat'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Deteksi'),
        centerTitle: true,
        leading: IconButton(
          icon:
              _isSaving
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.close),
          onPressed:
              _isSaving
                  ? null
                  : () async {
                    await _saveHistory();
                    Navigator.pop(context, true);
                  },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gambar:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final viewSize = constraints.biggest;
                  final scaleX = viewSize.width / widget.originalWidth;
                  final scaleY = viewSize.height / widget.originalHeight;
                  final scaledRect =
                      widget.boxRect != null
                          ? Rect.fromLTWH(
                            widget.boxRect!.left * viewSize.width,
                            widget.boxRect!.top * viewSize.height,
                            widget.boxRect!.width * viewSize.width,
                            widget.boxRect!.height * viewSize.height,
                          )
                          : null;
                  if (scaledRect != null) {
                    print(
                      '🟥 Scaled Bounding Box: '
                      'left=${scaledRect.left}, '
                      'top=${scaledRect.top}, '
                      'width=${scaledRect.width}, '
                      'height=${scaledRect.height}',
                    );
                  }
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(
                          widget.imageFile,
                          fit: BoxFit.contain,
                        ), // Ubah dari cover ke contain
                      ),
                      if (scaledRect != null)
                        Positioned(
                          left: scaledRect.left,
                          top: scaledRect.top,
                          width: scaledRect.width,
                          height: scaledRect.height,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              border: Border.all(color: Colors.green, width: 2),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Deteksi:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.result, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 20),
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
