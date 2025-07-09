import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

// Impor halaman Anda, pastikan path-nya benar
import '/screens/home_screen.dart';
import '/screens/result_screen.dart';

// --- Anda tidak perlu mengubah bagian ini ---
const Map<int, String> labelLuka = {
  0: 'Luka Lebam',
  1: 'Luka Gores',
  2: 'Luka Sayat',
  3: 'Luka Bakar',
};

const Map<int, String> rekomendasiLuka = {
  0: 'Kompres dingin dan istirahatkan area yang lebam.',
  1: 'Cuci luka dengan air bersih, oleskan antiseptik, dan tutup dengan perban.',
  2: 'Bersihkan luka, hentikan pendarahan ringan, tutup dengan kasa steril.',
  3: 'Segera bawa ke fasilitas medis. Jangan oleskan apapun ke luka bakar derajat 3.',
};
// -----------------------------------------

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? imageFile;
  final ImagePicker _picker = ImagePicker();
  late Interpreter _interpreter;
  final int _inputSize = 640;
  bool _modelLoaded = false;
  bool _isProcessing = false; // State untuk mengontrol loading indicator

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  @override
  void dispose() {
    _interpreter.close(); // Penting: Melepaskan sumber daya model
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/best_float32.tflite',
      );

      // Cetak bentuk input/output untuk verifikasi
      print("✅ Model berhasil dimuat.");
      print("   - Input shape: ${_interpreter.getInputTensor(0).shape}");
      print("   - Output shape: ${_interpreter.getOutputTensor(0).shape}");

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

    // Konversi gambar ke format List<double> dan normalisasi (0-1)
    final imageBytes = resizedImage.getBytes(order: img.ChannelOrder.rgb);
    final normalizedPixels = imageBytes.map((byte) => byte / 255.0).toList();

    // Ubah struktur list menjadi [1, 640, 640, 3]
    int pixelIndex = 0;
    final imageList = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (_) => List.generate(_inputSize, (_) {
          final r = normalizedPixels[pixelIndex++];
          final g = normalizedPixels[pixelIndex++];
          final b = normalizedPixels[pixelIndex++];
          return [r, g, b];
        }),
      ),
    );
    return imageList;
  }

  Future<void> _runModel() async {
    if (!_modelLoaded || imageFile == null || _isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final input = await _preprocessImage(imageFile!);

      final outputShape = _interpreter.getOutputTensor(0).shape;
      final classCount = outputShape[1] - 5; // Harusnya 6
      final detectionCount = outputShape[2]; // Harusnya 8400

      // Siapkan buffer output
      final output = List.filled(
        1 * (5 + classCount) * detectionCount,
        0.0,
      ).reshape([1, (5 + classCount), detectionCount]);

      // Jalankan inferensi
      _interpreter.run(input, output);

      double maxScore = 0.0;
      int bestClassIndex = -1;
      final rawOutput = output[0]; // Shape [11, 8400] atau [10, 8400]

      for (int i = 0; i < detectionCount; i++) {
        final confidence = sigmoid(rawOutput[4][i]);

        if (confidence < 0.3) continue; // Ambang batas kepercayaan

        // Ambil semua skor kelas (dari indeks 5 sampai akhir)
        final classScores = List.generate(
          classCount,
          (j) => sigmoid(rawOutput[5 + j][i]),
        );

        final maxClassScore = classScores.reduce(max);
        final classIndex = classScores.indexOf(maxClassScore);
        final score = confidence * maxClassScore;

        if (score > maxScore) {
          maxScore = score;
          bestClassIndex = classIndex;
        }
      }

      if (bestClassIndex != -1) {
        final hasilDeteksi = labelLuka[bestClassIndex] ?? 'Tidak Diketahui';
        final hasilRekomendasi =
            rekomendasiLuka[bestClassIndex] ?? 'Tidak ada rekomendasi';

        // Navigasi ke halaman hasil
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => ResultScreen(
                  result: hasilDeteksi,
                  rekomendasi: hasilRekomendasi,
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak ada luka yang terdeteksi dengan jelas.'),
          ),
        );
      }
    } catch (e) {
      print("❌ Terjadi error saat menjalankan model: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Terjadi error: $e')));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
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

  double sigmoid(double x) {
    return 1 / (1 + exp(-x));
  }

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
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(FeatherIcons.rotateCcw),
            onPressed: () {
              setState(() {
                imageFile = null;
              });
            },
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
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
                    elevation: 0,
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
