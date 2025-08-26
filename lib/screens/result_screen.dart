import 'dart:io';
import 'package:flutter/material.dart';
import '../services/injury_services.dart';
import '../widgets/cards/result_card.dart';
import '../widgets/lists/recommendation_list.dart';
// import '../widgets/lists/confidence_indicator.dart'; // Tambahkan import ini
import '../widgets/common/custom_app_bar.dart';
import '../l10n/app_localizations.dart';

/// Halaman hasil deteksi luka, menampilkan gambar dengan bounding box,
/// label luka, nilai confidence, dan rekomendasi penanganan.
class ResultScreen extends StatefulWidget {
  final String result; // Label hasil deteksi (misalnya: "Luka Bakar")
  final List<String> rekomendasi; // Daftar rekomendasi penanganan luka
  final double score; // Skor keyakinan model terhadap deteksi luka
  final File imageFile; // Gambar yang diproses/didapat dari deteksi
  final Rect?
  boxRect; // Bounding box dari objek luka (dalam format normalisasi 0-1)
  final int originalWidth; // Lebar asli gambar sebelum ditampilkan
  final int originalHeight; // Tinggi asli gambar sebelum ditampilkan

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
  bool _isSaved = false;

  /// Fungsi untuk menampilkan dialog input note
  Future<String?> _showNoteDialog() async {
    String noteText = '';
    final localizations = AppLocalizations.of(context)!;
    
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.note_add,
                color: Color(0xFF4299E1),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                localizations.addNote,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.addNoteDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: localizations.addNotePlaceholder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF4299E1)),
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
                onChanged: (value) {
                  noteText = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Batal
              },
              child: Text(
                localizations.cancel,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(noteText.isEmpty ? null : noteText);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4299E1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                localizations.save,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Fungsi untuk menyimpan riwayat hasil deteksi ke penyimpanan lokal/database
  Future<void> _saveHistory() async {
    if (_isSaving || _isSaved) return;

    // Tampilkan dialog untuk input note
    final note = await _showNoteDialog();
    
    // Jika user menekan batal, hentikan proses
    if (note == null && !mounted) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Simpan data deteksi menggunakan service
      await InjuryHistoryService().addInjuryHistoryWithImage(
        label: widget.result,
        imageFile: widget.imageFile,
        recommendation: widget.rekomendasi.join(', '),
        detectedAt: DateTime.now(),
        scores: widget.score,
        notes: note, // Tambahkan note ke parameter
      );

      // Tampilkan snackbar jika berhasil
      if (mounted) {
        final localizations = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(localizations.historySaved),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        
        // Set status sudah disimpan
        setState(() {
          _isSaved = true;
        });
      }
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print('❌ ${localizations.failedToSaveHistory}: $e');

      // Tampilkan snackbar error jika gagal
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Text(localizations.failedToSaveHistory),
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

  /// Widget yang menampilkan gambar hasil deteksi disertai bounding box
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

              // Hitung ulang posisi bounding box berdasarkan ukuran tampilan
              final scaledRect =
                  widget.boxRect != null
                      ? Rect.fromLTWH(
                        widget.boxRect!.left * viewSize.width,
                        widget.boxRect!.top * viewSize.height,
                        widget.boxRect!.width * viewSize.width,
                        widget.boxRect!.height * viewSize.height,
                      )
                      : null;

              // Cek apakah bounding box harus ditampilkan
              final shouldShowBoundingBox = scaledRect != null &&
                  widget.score >= 0.3;

              return Stack(
                children: [
                  // Tampilkan gambar utama
                  Positioned.fill(
                    child: Image.file(widget.imageFile, fit: BoxFit.cover),
                  ),
                  // Tampilkan bounding box jika kondisi terpenuhi
                  if (shouldShowBoundingBox)
                    Positioned(
                      left: scaledRect.left,
                      top: scaledRect.top,
                      width: scaledRect.width,
                      height: scaledRect.height,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          border: Border.all(color: Colors.green, width: 3),
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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: CustomAppBar(
        title: localizations.detectionResult,
        // Tombol close saja - tidak ada penyimpanan
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Kartu hasil gambar deteksi
              ResultCard(
                title: localizations.detectionImage,
                icon: Icons.image,
                customContent: _buildImageWithBoundingBox(),
              ),

              const SizedBox(height: 20),

              // Kartu jenis luka yang terdeteksi
              ResultCard(
                title: localizations.detectedWoundType,
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
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Kartu tingkat akurasi/confidence - hanya tampil jika score >= 0.3
              if (widget.score >= 0.3) ...[
                ResultCard(
                  title: localizations.detectionAccuracy,
                  icon: Icons.analytics,
                  customContent: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4299E1), // Biru terang
                          Color(0xFF3182CE), // Biru gelap
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
                            Icons.analytics,
                            color: Color(0xFF4299E1),
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localizations.confidenceLevel,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${(widget.score * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Progress indicator
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: widget.score,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Kartu rekomendasi penanganan luka
              // Di dalam build method, bagian RecommendationList
              ResultCard(
                title: localizations.treatmentRecommendation,
                icon: Icons.medical_information,
                customContent: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: RecommendationList(
                        recommendations: widget.rekomendasi,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Tombol Simpan ke Riwayat
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isSaving || _isSaved) ? null : _saveHistory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSaved 
                        ? Colors.green 
                        : const Color(0xFF4299E1),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: (_isSaved 
                        ? Colors.green 
                        : const Color(0xFF4299E1)).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isSaving
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              localizations.loading,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      : _isSaved
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  localizations.historySaved,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.save,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  localizations.saveToHistory,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
