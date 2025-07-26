import 'dart:io';
import 'package:flutter/material.dart';
import '../services/injury_services.dart';
import '../widgets/result_card.dart';
import '../widgets/recommendation_list.dart';
import '../widgets/generic_button.dart';
import '../widgets/custom_app_bar.dart';

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
      await InjuryHistoryService().addInjuryHistoryWithImage(
        label: widget.result,
        imageFile: widget.imageFile,
        recommendation: widget.rekomendasi.join(', '),
        detectedAt: DateTime.now(),
        scores: widget.score,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Riwayat berhasil disimpan'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Gagal menyimpan riwayat: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 12),
                Text('Gagal menyimpan riwayat'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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

  Widget _buildImageWithBoundingBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 1,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final viewSize = constraints.biggest;
              final scaledRect = widget.boxRect != null
                  ? Rect.fromLTWH(
                      widget.boxRect!.left * viewSize.width,
                      widget.boxRect!.top * viewSize.height,
                      widget.boxRect!.width * viewSize.width,
                      widget.boxRect!.height * viewSize.height,
                    )
                  : null;
              
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.file(
                      widget.imageFile,
                      fit: BoxFit.cover,
                    ),
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
                          border: Border.all(
                            color: Colors.green,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Text(
                              widget.result,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: CustomAppBar(
        title: 'Hasil Deteksi',
        leading: IconButton(
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
              : const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
          onPressed: _isSaving
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
          children: [
            // Gambar dengan bounding box
            ResultCard(
              title: 'Gambar Hasil Deteksi',
              icon: Icons.image,
              customContent: _buildImageWithBoundingBox(),
            ),
            
            const SizedBox(height: 20),
            
            // Hasil deteksi
            ResultCard(
              title: 'Jenis Luka Terdeteksi',
              icon: Icons.healing,
              customContent: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE53E3E), // Merah terang
                      Color(0xFFD53F8C), // Merah pink
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        color: Color(0xFFE53E3E),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.result,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Rekomendasi
            ResultCard(
              title: 'Rekomendasi Perawatan',
              icon: Icons.medical_information,
              customContent: RecommendationList(
                recommendations: widget.rekomendasi,
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
