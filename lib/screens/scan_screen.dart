import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_curativo/screens/main_tab_view.dart';
import '../screens/result_screen.dart';
import '../screens/home_screen.dart';
import '../services/injury_services.dart';

const Map<int, String> labelLuka = {
  0: 'Luka Lebam',
  1: 'Luka Gores',
  2: 'Luka Sayat',
  3: 'Luka Bakar',
};

const Map<int, List<String>> rekomendasiLuka = {
  0: [
    'Kompres dingin area yang lebam selama 10–15 menit setiap jam pada 24 jam pertama.',
    'Hindari tekanan berat pada area tersebut.',
    'Istirahatkan bagian tubuh yang terkena.',
    'Jika nyeri atau bengkak bertambah parah, segera konsultasi ke dokter.',
  ],
  1: [
    'Cuci luka dengan air bersih atau larutan saline.',
    'Keringkan dengan kain bersih dan oleskan antiseptik ringan.',
    'Tutup luka dengan perban steril.',
    'Ganti perban setiap hari dan hindari menggaruk luka.',
  ],
  2: [
    'Hentikan perdarahan dengan menekan luka menggunakan kain bersih.',
    'Setelah darah berhenti, bersihkan luka dengan air bersih.',
    'Oleskan antiseptik dan tutup dengan kasa steril.',
    'Jika luka dalam atau perdarahan berlanjut, segera ke fasilitas medis.',
  ],
  3: [
    'Dinginkan luka bakar dengan air mengalir selama 10–20 menit (hindari es).',
    'Tutup luka dengan kain bersih non-lengket.',
    'Jangan oleskan mentega, pasta gigi, atau bahan lain.',
    'Jika luka bakar parah (derajat 2/3), segera ke fasilitas medis.',
  ],
};

class ScanScreen extends StatefulWidget {
  final Function()? onScanCompleted; // optional callback

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
      final input = await _preprocessImage(imageFile!);
      // Ambil ukuran asli gambar (bukan hasil resize 640x640)
final originalImage = img.decodeImage(await imageFile!.readAsBytes())!;
final originalWidth = originalImage.width;
final originalHeight = originalImage.height;


      // Output shape = [1, 8, 8400]
      final output = List.generate(
        1,
        (_) => List.generate(8, (_) => List.filled(8400, 0.0)),
      );

      _interpreter.run(input, output);
      final rawOutput = List.generate(
        8400,
        (i) => List.generate(8, (j) => output[0][j][i]),
      ); // [8400][8]

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
          this.x = x - w / 2;  // koordinat x (kiri)
          this.y = y - h / 2;  // koordinat y (atas)
          this.w = w;          // lebar
          this.h = h;          // tinggi
          
          // Clamp nilai agar tetap dalam range 0-1
          this.x = this.x.clamp(0.0, 1.0);
          this.y = this.y.clamp(0.0, 1.0);
          this.w = this.w.clamp(0.0, 1.0 - this.x); // pastikan tidak melebihi batas kanan
          this.h = this.h.clamp(0.0, 1.0 - this.y); // pastikan tidak melebihi batas bawah
          
          // Debug print untuk koordinat yang sudah di-clamp
          print('🔧 Clamped coordinates: x=${this.x.toStringAsFixed(4)}, y=${this.y.toStringAsFixed(4)}, w=${this.w.toStringAsFixed(4)}, h=${this.h.toStringAsFixed(4)}');
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
              ? labelLuka[bestClassIndex] ?? 'Tidak Diketahui'
              : 'Luka tidak terdeteksi';

      final List<String> hasilRekomendasi =
          bestClassIndex != -1 ? rekomendasiLuka[bestClassIndex] ?? [] : [];

      final double hasilScore = bestClassIndex != -1 ? maxScore : 0.0;
      
      print('📦 Hasil Score: $hasilScore');
      print("📢 Deteksi selesai. ClassIndex: $bestClassIndex, Score: $maxScore");
      

      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        print('🔎 Final bestClassIndex=$bestClassIndex, maxScore=$maxScore');
        print('📤 Sending bounding box: x=${this.x}, y=${this.y}, w=${this.w}, h=${this.h}');
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              result: hasilDeteksi,
              rekomendasi: hasilRekomendasi,
              score: maxScore,
              imageFile: imageFile!,
              boxRect: Rect.fromLTWH(this.x, this.y, this.w, this.h), // Gunakan koordinat yang sudah di-clamp
              originalWidth: originalWidth,
              originalHeight: originalHeight
            ),
          ),
        );

        if (result == true || widget.onScanCompleted != null) {
          widget.onScanCompleted?.call();
        }
        
      }
    } catch (e) {
      print("❌ Error saat inferensi: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Terjadi error: $e')));
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
    }
  }

  void _showPickOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Kamera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Galeri'),
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

  double sigmoid(double x) => 1 / (1 + exp(-x));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pindai Luka',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(FeatherIcons.arrowLeft),
          onPressed:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainTabView()),
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.rotateCcw),
            onPressed: () => setState(() => imageFile = null),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 22),
              const Text(
                'Unggah foto luka',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => _showPickOptionsDialog(context),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFCCCCCC),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFF7F7F7),
                    image:
                        imageFile != null
                            ? DecorationImage(
                              image: FileImage(imageFile!),
                              fit: BoxFit.cover,
                            )
                            : null,
                  ),
                  child:
                      imageFile == null
                          ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 60,
                                color: Color(0xFFA0A0A0),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Ketuk untuk memilih foto',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          )
                          : null,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (imageFile == null || !_modelLoaded || _isProcessing)
                          ? null
                          : _runModel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000080),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child:
                      _isProcessing
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                          : const Text(
                            'PINDAI LUKA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
