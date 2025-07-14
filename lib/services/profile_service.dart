import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final String baseUrl = 'http://10.0.2.2:8000/api'; // ganti sesuai IP/server

  Future<String> _getEndpointPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role =
        prefs.getString('role') ?? 'user'; // default user jika tidak ada
    return '/$role/profile'; // contoh: /user/profile
  }

  Future<Map<String, dynamic>> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final path = await _getEndpointPath();

    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {'success': true, 'user': data['user']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal ambil data',
      };
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String noHp,
    required String jenisKelamin,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final path = await _getEndpointPath();

    final response = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'no_hp': noHp,
        'jenis_kelamin': jenisKelamin,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {
        'success': true,
        'user': data['user'],
        'message': data['message'],
      };
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Gagal update profil',
      };
    }
  }
}
