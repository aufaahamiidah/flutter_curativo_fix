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
  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  late Interpreter _interpreter;
  final int _inputSize = 640;
  bool _modelLoaded = false;
  bool _isProcessing = false;
  double x = 0, y = 0, w = 0, h = 0;

  // Lokalisasi untuk label luka
  Map<int, String> _getLabelLuka(AppLocalizations localizations) {
    return {
      0: localizations.bruiseWound,
      1: localizations.scratchWound,
      2: localizations.cutWound,
      3: localizations.burnWound,
    };
  }

  // Lokalisasi untuk rekomendasi luka
  Map<int, List<String>> _getRekomendasiLuka(AppLocalizations localizations) {
    return {
      0: [
        localizations.bruiseRecommendation1,
        localizations.bruiseRecommendation2,
        localizations.bruiseRecommendation3,
        localizations.bruiseRecommendation4,
      ],
      1: [
        localizations.scratchRecommendation1,
        localizations.scratchRecommendation2,
        localizations.scratchRecommendation3,
        localizations.scratchRecommendation4,
      ],
      2: [
        localizations.cutRecommendation1,
        localizations.cutRecommendation2,
        localizations.cutRecommendation3,
        localizations.cutRecommendation4,
      ],
      3: [
        localizations.burnRecommendation1,
        localizations.burnRecommendation2,
        localizations.burnRecommendation3,
        localizations.burnRecommendation4,
      ],
    };
  }

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

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

      final output = List.generate(
        1,
        (_) => List.generate(8, (_) => List.filled(8400, 0.0)),
      );

      _interpreter.run(input, output);
      final rawOutput = List.generate(
        8400,
        (i) => List.generate(8, (j) => output[0][j][i]),
      );

      double maxScore = 0.0;
      int bestClassIndex = -1;
      int bestIndex = -1;

      print("🧪 Semua Skor > 0.3:");
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

        // Menghitung koordinat bounding box
        if (score > 0.3 && score > maxScore) {
          maxScore = score;
          bestClassIndex = classIndex;
          bestIndex = i;
          print("🧩 Index $i Score: $maxScore");
          print("🧩 Index $i Score: $bestClassIndex");

          // Koordinat bounding box dalam format normalized (0-1)
          this.x = x - w / 2; // koordinat x (kiri)
          this.y = y - h / 2; // koordinat y (atas)
          this.w = w; // lebar
          this.h = h; // tinggi

          // Clamp nilai agar tetap dalam range 0-1
          this.x = this.x.clamp(0.0, 1.0);
          this.y = this.y.clamp(0.0, 1.0);
          this.w = this.w.clamp(
            0.0,
            1.0 - this.x,
          ); // pastikan tidak melebihi batas kanan
          this.h = this.h.clamp(
            0.0,
            1.0 - this.y,
          ); // pastikan tidak melebihi batas bawah

          // Debug print untuk koordinat yang sudah di-clamp
          print(
            '🔧 Clamped coordinates: x=${this.x.toStringAsFixed(4)}, y=${this.y.toStringAsFixed(4)}, w=${this.w.toStringAsFixed(4)}, h=${this.h.toStringAsFixed(4)}',
          );
        }
      }

      if (bestIndex != -1) {
        // Hapus deklarasi variabel lokal ini:
        // final bestBox = rawOutput[bestIndex];
        // final x = bestBox[0];
        // final y = bestBox[1];
        // final w = bestBox[2];
        // final h = bestBox[3];

        print('🚫 Deteksi berhasil dengan koordinat yang sudah di-clamp.');
      } else {
        print('🚫 Tidak ada deteksi dengan skor di atas threshold.');
      }

      final String hasilDeteksi =
          bestClassIndex != -1
              ? labelLuka[bestClassIndex] ?? localizations.unknownWound
              : localizations.woundNotDetected;

      final List<String> hasilRekomendasi =
          bestClassIndex != -1 ? rekomendasiLuka[bestClassIndex] ?? [] : [];

      final double hasilScore = (bestClassIndex != -1 && maxScore >= 3) ? maxScore : -1.0;

      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
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

        if (result == true || widget.onScanCompleted != null) {
          widget.onScanCompleted?.call();
        }
      }
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      print("❌ Error saat inferensi: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${localizations.errorOccurred}: $e')),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

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
      }
    } catch (e) {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${localizations.failedToPickImage}: $e')),
      );
    }
  }

  void _showPickOptionsDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: CustomAppBar(
        title: localizations.scanWound,
      ),
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
              
              ImagePickerCard(
                imageFile: imageFile,
                onTap: () => _showPickOptionsDialog(context),
                hintText: localizations.tapToSelectPhoto,
                height: 280,
              ),
              
              const SizedBox(height: 24),
              
              ScanInstructionCard(
                instructions: [
                  localizations.scanInstruction1,
                  localizations.scanInstruction2,
                  localizations.scanInstruction3,
                  localizations.scanInstruction4,
                ],
              ),
              
              const SizedBox(height: 32),
              
              Center(
                child: GenericButton(
                  text: _isProcessing ? localizations.processing : localizations.scanWound.toUpperCase(),
                  onPressed: (imageFile == null || !_modelLoaded || _isProcessing)
                      ? () {}
                      : _runModel,
                  type: ButtonType.elevated,
                  backgroundColor: (imageFile == null || !_modelLoaded || _isProcessing)
                      ? Colors.grey[400]
                      : const Color(0xFFE53E3E),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                  borderRadius: BorderRadius.circular(12),
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
