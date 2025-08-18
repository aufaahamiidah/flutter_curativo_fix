import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_curativo/screens/main_tab_view.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import '../screens/result_screen.dart';
import '../widgets/cards/image_picker_card.dart';
import '../widgets/cards/scan_instruction_card.dart';
import '../widgets/common/generic_button.dart';
import '../widgets/common/custom_app_bar.dart';

class ScanScreen extends StatefulWidget {
  final Function()? onScanCompleted;

  const ScanScreen({Key? key, this.onScanCompleted}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? imageFile; // Menyimpan file gambar yang dipilih
  final ImagePicker _picker =
      ImagePicker(); // Untuk memilih gambar dari kamera/galeri
  late Interpreter _interpreter; // Model TFLite
  final int _inputSize = 640; // Ukuran input model
  bool _modelLoaded = false; // Status apakah model sudah dimuat
  bool _isProcessing = false; // Status apakah model sedang memproses gambar
  double x = 0, y = 0, w = 0, h = 0; // Koordinat dan ukuran bounding box

  // Lokalisasi label luka
  Map<int, String> _getLabelLuka(AppLocalizations localizations) {
    return {
      0: localizations.bruiseWound,
      1: localizations.scratchWound,
      2: localizations.cutWound,
      3: localizations.burnWound,
    };
  }

  // Lokalisasi rekomendasi untuk setiap jenis luka
  Map<int, List<String>> _getRekomendasiLuka(AppLocalizations localizations) {
    return {
      0: [
        localizations.bruiseRecommendation1,
        localizations.bruiseRecommendation2,
        localizations.bruiseRecommendation3,
        localizations.bruiseRecommendation4,
        localizations.bruiseRecommendation5,
        localizations.bruiseRecommendation6,
        localizations.bruiseRecommendation7,
        localizations.bruiseRecommendation8,
      ],
      1: [
        localizations.scratchRecommendation1,
        localizations.scratchRecommendation2,
        localizations.scratchRecommendation3,
        localizations.scratchRecommendation4,
        localizations.scratchRecommendation5,
        localizations.scratchRecommendation6,
        localizations.scratchRecommendation7,
      ],
      2: [
        localizations.cutRecommendation1,
        localizations.cutRecommendation2,
        localizations.cutRecommendation3,
        localizations.cutRecommendation4,
        localizations.cutRecommendation5,
        localizations.cutRecommendation6,
        localizations.cutRecommendation7,
        localizations.cutRecommendation8,
      ],
      3: [
        localizations.burnRecommendation1,
        localizations.burnRecommendation2,
        localizations.burnRecommendation3,
        localizations.burnRecommendation4,
        localizations.burnRecommendation5,
        localizations.burnRecommendation6,
        localizations.burnRecommendation7,
        localizations.burnRecommendation8,
        localizations.burnRecommendation9,
        localizations.burnRecommendation10,
        localizations.burnRecommendation11,
        localizations.burnRecommendation12,
      ],
    };
  }

  @override
  void initState() {
    super.initState();
    _loadModel(); // Memuat model saat inisialisasi
  }

  @override
  void dispose() {
    _interpreter.close(); // Menutup interpreter saat widget dihancurkan
    super.dispose();
  }

  // Fungsi untuk memuat model TFLite
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/best_float16.tflite',
      );
      setState(() => _modelLoaded = true);
    } catch (e) {
      print("❌ Gagal memuat model: $e");
    }
  }

  // Pra-pemrosesan gambar sebelum dikirim ke model
  Future<List<List<List<List<double>>>>> _preprocessImage(
    File imageFile,
  ) async {
    final bytes = await imageFile.readAsBytes();
    final rawImage = img.decodeImage(bytes);

    final resizedImage = img.copyResize(
      rawImage!,
      width: _inputSize,
      height: _inputSize,
    );

    final imageBytes = resizedImage.getBytes(order: img.ChannelOrder.rgb);

    final input = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(_inputSize, (x) {
          final index = (y * _inputSize + x) * 3;
          final r = imageBytes[index] / 255.0;
          final g = imageBytes[index + 1] / 255.0;
          final b = imageBytes[index + 2] / 255.0;
          return [r, g, b];
        }),
      ),
    );

    return input;
  }

  // Fungsi untuk menjalankan inferensi model
  Future<void> _runModel() async {
    if (!_modelLoaded || imageFile == null || _isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final localizations = AppLocalizations.of(context)!;
      final labelLuka = _getLabelLuka(localizations);
      final rekomendasiLuka = _getRekomendasiLuka(localizations);

      final input = await _preprocessImage(imageFile!);
      final originalImage = img.decodeImage(await imageFile!.readAsBytes())!;
      final originalWidth = originalImage.width;
      final originalHeight = originalImage.height;

      // Output format model YOLO
      final output = List.generate(
        1,
        (_) => List.generate(8, (_) => List.filled(8400, 0.0)),
      );

      _interpreter.run(input, output);

      // Transformasi output ke format usable
      final rawOutput = List.generate(
        8400,
        (i) => List.generate(8, (j) => output[0][j][i]),
      );

      double maxScore = 0.0;
      int bestClassIndex = -1;
      int bestIndex = -1;

      for (int i = 0; i < 8400; i++) {
        final x = rawOutput[i][0];
        final y = rawOutput[i][1];
        final w = rawOutput[i][2];
        final h = rawOutput[i][3];
        final classScores = rawOutput[i].sublist(4);

        final classIndex = classScores.indexWhere(
          (score) => score == classScores.reduce(max),
        );
        final score = classScores[classIndex];

        // Ambil hasil dengan skor terbaik
        if (score > 0.3 && score > maxScore) {
          maxScore = score;
          bestClassIndex = classIndex;
          bestIndex = i;

          this.x = (x - w / 2).clamp(0.0, 1.0);
          this.y = (y - h / 2).clamp(0.0, 1.0);
          this.w = w.clamp(0.0, 1.0 - this.x);
          this.h = h.clamp(0.0, 1.0 - this.y);
        }
      }

      final String hasilDeteksi =
          bestClassIndex != -1
              ? labelLuka[bestClassIndex] ?? localizations.unknownWound
              : localizations.woundNotDetected;
      final List<String> hasilRekomendasi =
          bestClassIndex != -1 ? rekomendasiLuka[bestClassIndex] ?? [] : [];

      await Future.delayed(const Duration(milliseconds: 800));

      // Pindah ke halaman hasil deteksi
      if (mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ResultScreen(
                  result: hasilDeteksi,
                  rekomendasi: hasilRekomendasi,
                  score: maxScore,
                  imageFile: imageFile!,
                  boxRect: Rect.fromLTWH(this.x, this.y, this.w, this.h),
                  originalWidth: originalWidth,
                  originalHeight: originalHeight,
                ),
          ),
        );

        // Hapus gambar setelah kembali dari result screen
        if (result == true || widget.onScanCompleted != null) {
          setState(() {
            imageFile = null; // Hapus gambar
          });
          widget.onScanCompleted?.call();
        }
      }
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${localizations.errorOccurred}: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  // Menampilkan opsi pilih gambar (kamera/galeri)
  void _showPickOptionsDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(localizations.camera),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(localizations.gallery),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  // Fungsi untuk memilih gambar dari kamera/galeri
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxHeight: 640,
        maxWidth: 640,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() => imageFile = File(pickedFile.path));
        // Langsung jalankan scan setelah gambar dipilih
        if (_modelLoaded) {
          _runModel();
        }
      }
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${localizations.failedToPickImage}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: CustomAppBar(title: localizations.scanWound),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.uploadPhoto,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),

              // Kartu untuk memilih gambar dengan overlay loading
              Stack(
                children: [
                  ImagePickerCard(
                    imageFile: imageFile,
                    onTap: _isProcessing ? () {} : () => _showPickOptionsDialog(context),
                    hintText: localizations.tapToSelectPhoto,
                    height: 280,
                  ),
                  // Overlay loading animation
                  if (_isProcessing)
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFFE53E3E),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations.processScan,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Kartu instruksi pemindaian luka
              ScanInstructionCard(
                instructions: [
                  localizations.scanInstruction1,
                  localizations.scanInstruction2,
                  localizations.scanInstruction3,
                  localizations.scanInstruction4,
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
