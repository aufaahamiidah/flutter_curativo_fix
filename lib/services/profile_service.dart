import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final String baseUrl = 'https://teal-walrus-824468.hostingersite.com/api';

  Future<Map<String, dynamic>> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getString('id');
    final role = prefs.getString('role') ?? 'user';
    final path = '/$role/profile/$id';

    try {
      final response = await http.get(
        Uri.parse('$baseUrl$path'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          return {'success': true, 'user': data['data']};
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Gagal ambil data',
          };
        }
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Akses ditolak: Anda tidak berhak mengakses profil ini',
        };
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Unauthorized: Silakan login ulang',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal ambil data',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }
}
