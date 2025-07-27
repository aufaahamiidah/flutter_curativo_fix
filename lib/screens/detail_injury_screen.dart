import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/cards/result_card.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailScreen({super.key, required this.data});

  String formatTanggal(String isoDateString) {
    try {
      final dateTime = DateTime.parse(isoDateString).toLocal();
      final hari = DateFormat('EEEE', 'id_ID').format(dateTime);
      final tanggal = DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(dateTime);
      return '$hari, $tanggal';
    } catch (e) {
      return '-';
    }
  }

  List<String> _parseRecommendationToPoints(String recommendation) {
    // Memecah rekomendasi berdasarkan tanda titik, koma, atau kata kunci
    List<String> points = [];
    
    // Split berdasarkan tanda titik dan bersihkan
    List<String> sentences = recommendation.split('.');
    
    for (String sentence in sentences) {
      String cleaned = sentence.trim();
      if (cleaned.isNotEmpty && cleaned.length > 3) {
        // Hapus tanda kurung dan angka di awal jika ada
        cleaned = cleaned.replaceAll(RegExp(r'^\([^)]*\),?\s*'), '');
        cleaned = cleaned.replaceAll(RegExp(r'^\d+[.)],?\s*'), '');
        
        if (cleaned.isNotEmpty) {
          points.add(cleaned);
        }
      }
    }
    
    // Jika tidak ada poin yang ditemukan, kembalikan teks asli sebagai satu poin
    if (points.isEmpty) {
      points.add(recommendation);
    }
    
    return points;
  }

  Widget _buildImageSection(String? imageUrl) {
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
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
                imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
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
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF000080)),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
              )
            : _buildNoImage(),
      ),
    );
  }

  Widget _buildErrorImage() {
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
          Icon(
            Icons.broken_image_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Gagal memuat gambar',
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

  Widget _buildNoImage() {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
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
            'Tidak ada gambar',
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF000080).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF000080),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
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

  Widget _buildRecommendationCard(String recommendation) {
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
              const Expanded(
                child: Text(
                  'Rekomendasi Penanganan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
    final detectedAt = data['detected_at'] ?? '';
    final label = data['label'] ?? '-';
    final recommendation = data['recommendation'] ?? '-';
    final imageUrl = data['image'];

    final rawScore = data['scores'];
    final doubleScore = rawScore is double
        ? rawScore
        : double.tryParse(rawScore.toString()) ?? 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const CustomAppBar(
        title: 'Detail Hasil Deteksi',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan gambar
            _buildImageSection(imageUrl),
            const SizedBox(height: 24),
            
            // Jenis Luka
            _buildInfoCard(
              title: 'Jenis Luka Terdeteksi',
              content: label,
              icon: Icons.medical_services_outlined,
              backgroundColor: const Color(0xFFF0F8FF),
            ),
            
            // Tingkat Keyakinan (hanya jika >= 0.3) - Tanpa warna
            if (doubleScore >= 0.3) 
              _buildInfoCard(
                title: 'Tingkat Keyakinan',
                content: '${(doubleScore * 100).toStringAsFixed(1)}%',
                icon: Icons.analytics_outlined,
              ),
            
            // Tanggal Deteksi
            _buildInfoCard(
              title: 'Waktu Deteksi',
              content: formatTanggal(detectedAt),
              icon: Icons.access_time_outlined,
            ),
            
            // Rekomendasi dengan bullet points
            _buildRecommendationCard(recommendation),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
