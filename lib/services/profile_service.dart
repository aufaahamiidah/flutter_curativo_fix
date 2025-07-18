import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final String baseUrl = 'https://4a4ebdb11b48.ngrok-free.app/api';

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

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
    required String noHp,
    required String jenisKelamin,
    String? tanggalLahir,
    String? password,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final id = prefs.getString('id');
    final role = prefs.getString('role') ?? 'user';
    final path = '/$role/profile/$id';

    Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'no_telp': noHp,
      'jenis_kelamin': jenisKelamin,
    };
    if (tanggalLahir != null) {
      body['tanggal_lahir'] = tanggalLahir;
    }
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    try {
      final response = await http.put(
        Uri.parse('$baseUrl$path'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          return {
            'success': true,
            'user': data['data'],
            'message': data['message'],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Gagal update profil',
          };
        }
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Akses ditolak: Anda tidak berhak mengubah profil ini',
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
          'message': data['message'] ?? 'Gagal update profil',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }
}
