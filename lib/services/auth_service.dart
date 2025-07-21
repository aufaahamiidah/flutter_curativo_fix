import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      'https://teal-walrus-824468.hostingersite.com/api'; // gunakan 127.0.0.1 jika bukan emulator

  /// Fungsi Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password},
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('role', data['user']['role']);
        await prefs.setString('name', data['user']['name']);
        await prefs.setString('email', data['user']['email']); // tambahkan ini
        await prefs.setString('id', data['user']['id']); // tambahkan ini
        return {'success': true, 'user': data['user']};
      } else {
        final message = data['message'] ?? 'Login gagal';
        print('⚠️ Login gagal: $message');
        return {'success': false, 'message': message};
      }
    } catch (e) {
      print('❌ [ERROR LOGIN] $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan pada saat login. Pastikan server aktif.',
      };
    }
  }

  /// Fungsi Register
  Future<Map<String, dynamic>> registerWithDetails({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String gender,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Accept': 'application/json'},
        body: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
          'no_telp': phone,
          'jenis_kelamin': gender,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('role', data['user']['role']);
        await prefs.setString('name', data['user']['name']);
        await prefs.setString('id', data['user']['id'].toString());
        await prefs.setString('email', data['user']['email']);

        return {'success': true, 'user': data['user']};
      } else {
        final message = data['message'] ?? 'Register gagal';
        print('⚠️ Register gagal: $message');
        return {'success': false, 'message': message};
      }
    } catch (e) {
      print('❌ [ERROR REGISTER] $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat mendaftar. Coba lagi nanti.',
      };
    }
  }

  /// Logout (hapus token)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('id');
    print('👋 Logout: Token dan data user dihapus');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  /// Ambil token dari penyimpanan
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Ambil role
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  /// Ambil nama user
  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<Map<String, String?>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'role': prefs.getString('role'),
      'id': prefs.getString('id'),
    };
  }
}
