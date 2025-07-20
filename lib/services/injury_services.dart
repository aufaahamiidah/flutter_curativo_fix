import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InjuryHistoryService {
  final String baseUrl = 'https://f79dd42978fe.ngrok-free.app/api';

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
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
    
  }
}
