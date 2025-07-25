import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_service.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class InjuryHistoryService {
  final String baseUrl = 'https://teal-walrus-824468.hostingersite.com/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String> _getRolePath() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? 'user';
    return '/$role/injury-history';
  }

  /// ✅ Ambil semua riwayat luka
  Future<List<dynamic>> fetchInjuryHistory() async {
    final token = await _getToken();
    final path = await _getRolePath();
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal mengambil riwayat luka');
    }
  }

  /// ✅ Ambil detail luka berdasarkan ID (fungsi show di Laravel)
  Future<Map<String, dynamic>> getInjuryDetail(String id) async {
    final token = await _getToken();
    final path = await _getRolePath();
    final response = await http.get(
      Uri.parse('$baseUrl$path/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );
    print('📡 [API] Response Code: ${response.statusCode}');
    print('📡 [API] Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Gagal mengambil detail luka');
    }
  }

  /// Tambah riwayat luka
  Future<bool> addInjuryHistory({
    required String label,
    String? image,
    String? location,
    String? notes,
    String? recommendation,
    required DateTime detectedAt,
    double? scores,
  }) async {
    final token = await _getToken();
    final path = await _getRolePath();
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'label': label,
        if (image != null) 'image': image,
        if (location != null) 'location': location,
        if (notes != null) 'notes': notes,
        if (recommendation != null) 'recommendation': recommendation,
        'detected_at': detectedAt.toIso8601String(),
        if (scores != null) 'scores': scores.toString(),
      },
    );

    return response.statusCode == 201;
  }

  Future<File> compressToWebP(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.webp';
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      format: CompressFormat.webp,
      quality: 80,
    );
    return File(result?.path ?? file.path);
  }

  /// ✅ Perbarui riwayat luka
  Future<bool> updateInjuryHistory({
    required String id,
    required String label,
    String? image,
    String? location,
    String? notes,
    String? recommendation,
    required DateTime detectedAt,
    double? scores,
  }) async {
    final token = await _getToken();
    final path = await _getRolePath();
    final response = await http.put(
      Uri.parse('$baseUrl$path/$id'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      body: {
        'label': label,
        if (image != null) 'image': image,
        if (location != null) 'location': location,
        if (notes != null) 'notes': notes,
        if (recommendation != null) 'recommendation': recommendation,
        'detected_at': detectedAt.toIso8601String(),
        if (scores != null) 'scores': scores.toString(),
      },
    );

    return response.statusCode == 200;
  }

  /// ✅ Hapus riwayat luka
  Future<bool> deleteInjuryHistory(String id) async {
    final token = await _getToken();
    final path = await _getRolePath();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$path/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
  }

  /// Tambah riwayat luka dengan upload gambar ke Supabase
  Future<bool> addInjuryHistoryWithImage({
    required String label,
    File? imageFile,
    String? location,
    String? notes,
    String? recommendation,
    required DateTime detectedAt,
    double? scores,
  }) async {
    try {
      String? imageUrl;

      // Upload gambar ke Supabase jika ada
      if (imageFile != null) {
        final compressedImage = await compressToWebP(imageFile);
        final fileName = SupabaseService.generateFileName(compressedImage.path);
        print('🖼️ [Upload] Generated filename: $fileName');
        imageUrl = await SupabaseService.uploadImage(
          imageFile: imageFile,
          fileName: fileName,
          folder: 'injuries', // Folder khusus untuk gambar luka
        );

        if (imageUrl == null) {
          throw Exception('Gagal mengupload gambar');
        }
      }
      print('📤 [API] Sending data to Laravel API...');
      print('📝 Label: $label');
      print('🖼️ Image URL: $imageUrl');
      print('🕒 Detected At: $detectedAt');
      print('📈 Score: $scores');
      print('💡 Recommendation: $recommendation');

      // Kirim data ke API dengan URL gambar dari Supabase
      final success = await addInjuryHistory(
        label: label,
        image: imageUrl,
        location: location,
        notes: notes,
        recommendation: recommendation,
        detectedAt: detectedAt,
        scores: scores,
      );

      print(
        success
            ? '✅ [API] Riwayat berhasil disimpan.'
            : '❌ [API] Gagal menyimpan riwayat.',
      );

      return success;
    } catch (e) {
      print('❌ [Service] Error adding injury history with image: $e');
      return false;
    }
  }

  /// Update riwayat luka dengan upload gambar baru ke Supabase
  Future<bool> updateInjuryHistoryWithImage({
    required String id,
    required String label,
    File? newImageFile,
    String? currentImageUrl,
    String? location,
    String? notes,
    String? recommendation,
    required DateTime detectedAt,
    double? scores,
  }) async {
    try {
      String? imageUrl = currentImageUrl;

      // Upload gambar baru jika ada
      if (newImageFile != null) {
        final fileName = SupabaseService.generateFileName(newImageFile.path);
        final newImageUrl = await SupabaseService.uploadImage(
          imageFile: newImageFile,
          fileName: fileName,
          folder: 'injuries',
        );

        if (newImageUrl != null) {
          imageUrl = newImageUrl;

          // Hapus gambar lama jika ada
          if (currentImageUrl != null && currentImageUrl.isNotEmpty) {
            // Extract file path dari URL untuk menghapus
            final uri = Uri.parse(currentImageUrl);
            final pathSegments = uri.pathSegments;
            if (pathSegments.length >= 3) {
              final filePath = pathSegments.sublist(2).join('/');
              await SupabaseService.deleteImage(filePath);
            }
          }
        }
      }

      // Update data di API
      return await updateInjuryHistory(
        id: id,
        label: label,
        image: imageUrl,
        location: location,
        notes: notes,
        recommendation: recommendation,
        detectedAt: detectedAt,
        scores: scores,
      );
    } catch (e) {
      print('Error updating injury history with image: $e');
      return false;
    }
  }
}
