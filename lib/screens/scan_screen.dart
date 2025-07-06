import 'dart:io';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '/screens/home_screen.dart';
import '/screens/result_screen.dart';

const Map<int, String> labelLuka = {
  0: 'Luka Lebam',
  1: 'Luka Gores',
  2: 'Luka Sayat',
  3: 'Luka Bakar Derajat 3',
  4: 'Luka Bakar Derajat 2',
  // 5: 'Luka Bakar Derajat 1',
};

const Map<int, String> rekomendasiLuka = {
  0: 'Kompres dingin dan istirahatkan area yang lebam.',
  1: 'Cuci luka dengan air bersih, oleskan antiseptik, dan tutup dengan perban.',
  2: 'Bersihkan luka, hentikan pendarahan ringan, tutup dengan kasa steril.',
  3: 'Segera bawa ke fasilitas medis. Jangan oleskan apapun ke luka bakar derajat 3.',
  4: 'Gunakan salep luka bakar, hindari pecahnya lepuhan. Bila parah, hubungi dokter.',
  // 5: 'Dinginkan luka dengan air mengalir 10-15 menit, lalu tutup longgar dengan kain bersih.',
};

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
  String _result = '';
  String _rekomendasi = '';

  @override
  void initState() {
    super.initState();
    print('🚀 initState dimulai');
    _loadModel();
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
              if (_result.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deteksi: $_result',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Rekomendasi: $_rekomendasi',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (imageFile == null || !_modelLoaded)
                          ? null
                          : () {
                            _runModel();
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF000080),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
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

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/best_float32.tflite',
      );
      _interpreter.allocateTensors();
      setState(() => _modelLoaded = true);
    } catch (e) {
      print("Gagal load model: $e");
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(
    File imageFile,
  ) async {
    final rawImage = img.decodeImage(await imageFile.readAsBytes());
    final resizedImage = img.copyResize(
      rawImage!,
      width: _inputSize,
      height: _inputSize,
    );

    final bytes = resizedImage.getBytes(order: img.ChannelOrder.rgb);

    int index = 0;
    List<List<List<List<double>>>> imageList = [
      List.generate(
        _inputSize,
        (y) => List.generate(_inputSize, (x) {
          final r = bytes[index++] / 255.0;
          final g = bytes[index++] / 255.0;
          final b = bytes[index++] / 255.0;
          return [r, g, b];
        }),
      ),
    ];

    return imageList;
  }

  Future<void> _runModel() async {
    if (!_modelLoaded || imageFile == null) {
      print("❌ Model belum siap atau gambar belum dipilih.");
      return;
    }

    final input = await _preprocessImage(imageFile!);
    final inputBuffer = input.reshape([1, _inputSize, _inputSize, 3]);
    // final rawOutput = List.generate(10, (_) => List.filled(8400, 0.0));
    // final outputBuffer = [rawOutput];
    final outputBuffer = List.generate(
      1,
      (_) => List.generate(10, (_) => List.filled(8400, 0.0)),
    );

    _interpreter.run(inputBuffer, outputBuffer);

    final rawOutput = outputBuffer[0]; // [10][8400]
    final detections = List.generate(
      8400,
      (i) => List.generate(10, (j) => rawOutput[j][i]),
    );
    print('Sample detection: ${detections[0]}');
    // final detections = List.generate(
    //   8400,
    //   (i) => List.generate(10, (j) => rawOutput[j][i]),
    // );
    // final detections = outputBuffer[0];

    double maxScore = -1.0;
    int maxClassIndex = -1;

    for (var det in detections) {
      final objectness = det[4];
      if (objectness < 0.25) continue; 
      if (det.length < 5 + labelLuka.length) continue;

      for (int classIndex = 0; classIndex < 5; classIndex++) {
        final classProb = det[5 + classIndex];
        final score = objectness * classProb;

        print('Objectness: $objectness, Score: $score for class $classIndex');

        if (score > maxScore) {
          maxScore = score;
          maxClassIndex = classIndex;
        }
      }
    }

    print('🔍 maxClassIndex: $maxClassIndex');
    print('✅ maxScore: $maxScore');

    final hasilDeteksi = labelLuka[maxClassIndex] ?? 'Tidak diketahui';
    final hasilRekomendasi =
        rekomendasiLuka[maxClassIndex] ?? 'Tidak ada rekomendasi';

    setState(() {
      _result = hasilDeteksi;
      _rekomendasi = hasilRekomendasi;
    });

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

    // Setelah kembali dari ResultScreen, reset hasil deteksi
    setState(() {
      _result = '';
      _rekomendasi = '';
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
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
}
