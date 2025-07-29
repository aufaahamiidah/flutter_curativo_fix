import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import '../widgets/common/custom_app_bar.dart';
// import '../widgets/cards/result_card.dart'; // Komponen ini belum digunakan

// Kelas stateless untuk menampilkan detail hasil deteksi luka
class DetailScreen extends StatelessWidget {
  // Data hasil deteksi yang dikirim dari layar sebelumnya
  final Map<String, dynamic> data;

  const DetailScreen({super.key, required this.data});

  // Fungsi untuk memformat tanggal ISO menjadi format lokal yang lebih terbaca
  String formatTanggal(String isoDateString, String locale) {
    try {
      final dateTime = DateTime.parse(isoDateString).toLocal();
      final hari = DateFormat('EEEE', locale).format(dateTime);
      final tanggal = DateFormat('dd/MM/yyyy HH:mm', locale).format(dateTime);
      return '$hari, $tanggal';
    } catch (e) {
      // Jika parsing gagal, kembalikan simbol "-"
      return '-';
    }
  }

  // Fungsi untuk memecah string rekomendasi menjadi daftar poin bullet
  List<String> _parseRecommendationToPoints(String recommendation) {
    List<String> points = [];

    // Pisahkan berdasarkan titik
    List<String> sentences = recommendation.split('.');

    for (String sentence in sentences) {
      String cleaned = sentence.trim();
      if (cleaned.isNotEmpty && cleaned.length > 3) {
        // Hapus angka/penomoran/kata pengantar di awal
        cleaned = cleaned.replaceAll(RegExp(r'^\([^)]*\),?\s*'), '');
        cleaned = cleaned.replaceAll(RegExp(r'^\d+[.)],?\s*'), '');
        cleaned = cleaned.replaceAll(RegExp(r'^,\s*'), '');
        cleaned = cleaned.replaceAll(RegExp(r',\s*$'), '');
        cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

        if (cleaned.isNotEmpty) {
          points.add(cleaned);
        }
      }
    }

    // Jika tidak berhasil dipecah, kembalikan sebagai satu poin
    if (points.isEmpty) {
      String cleanedOriginal =
          recommendation
              .replaceAll(RegExp(r'^,\s*'), '')
              .replaceAll(RegExp(r',\s*$'), '')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
      points.add(cleanedOriginal);
    }

    return points;
  }

  // Widget untuk membangun tampilan gambar deteksi
  Widget _buildImageSection(String? imageUrl, BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
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
        child:
            imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    // Tampilan saat gambar masih dimuat
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF000080),
                          ),
                        ),
                      ),
                    );
                  },
                  // Tampilan saat terjadi error memuat gambar
                  errorBuilder:
                      (context, error, stackTrace) => _buildErrorImage(context),
                )
                : _buildNoImage(context), // Tampilan jika tidak ada gambar
      ),
    );
  }

  // Widget fallback jika gambar gagal dimuat
  Widget _buildErrorImage(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            localizations.failedToLoadImage,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget fallback jika gambar tidak tersedia
  Widget _buildNoImage(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            localizations.noImage,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membuat kartu informasi (jenis luka, confidence, waktu deteksi)
  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    Color? backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF000080).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikon informasi
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF000080).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF000080), size: 24),
          ),
          const SizedBox(width: 16),
          // Konten teks informasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget khusus untuk menampilkan rekomendasi penanganan sebagai bullet points
  Widget _buildRecommendationCard(
    String recommendation,
    AppLocalizations localizations,
  ) {
    final points = _parseRecommendationToPoints(recommendation);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF000080).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header rekomendasi
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF000080).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Color(0xFF000080),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  localizations.treatmentRecommendationTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // List rekomendasi sebagai bullet point
          ...points.asMap().entries.map((entry) {
            final index = entry.key;
            final point = entry.value;

            return Padding(
              padding: EdgeInsets.only(
                bottom: index < points.length - 1 ? 12 : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titik bullet
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF000080),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Teks rekomendasi
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF666666),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Ambil data dari parameter yang dikirim ke halaman
    final detectedAt = data['detected_at'] ?? '';
    final label = data['label'] ?? '-';
    final recommendation = data['recommendation'] ?? '-';
    final imageUrl = data['image'];

    // Ambil locale saat ini untuk format tanggal
    final currentLocale = Localizations.localeOf(context);
    final localeString = currentLocale.languageCode == 'id' ? 'id_ID' : 'en_US';

    // Parsing skor ke bentuk double
    final rawScore = data['scores'];
    final doubleScore =
        rawScore is double
            ? rawScore
            : double.tryParse(rawScore.toString()) ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(title: localizations.detailDetectionResult),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar hasil deteksi
            _buildImageSection(imageUrl, context),
            const SizedBox(height: 24),

            // Menampilkan jenis luka
            _buildInfoCard(
              title: localizations.detectedWoundType,
              content: label,
              icon: Icons.medical_services_outlined,
              backgroundColor: const Color(0xFFF0F8FF),
            ),

            // Menampilkan tingkat keyakinan jika nilainya >= 0.3
            if (doubleScore >= 0.3)
              _buildInfoCard(
                title: localizations.confidenceLevel,
                content: '${(doubleScore * 100).toStringAsFixed(1)}%',
                icon: Icons.analytics_outlined,
              ),

            // Menampilkan waktu deteksi dengan format lokal
            _buildInfoCard(
              title: localizations.detectionTime,
              content: formatTanggal(detectedAt, localeString),
              icon: Icons.access_time_outlined,
            ),

            // Menampilkan rekomendasi penanganan luka
            _buildRecommendationCard(recommendation, localizations),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
