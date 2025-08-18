import 'dart:convert'; // Untuk konversi data JSON
import 'package:http/http.dart' as http; // Untuk melakukan HTTP request
import 'package:shared_preferences/shared_preferences.dart'; // Untuk menyimpan data lokal

/// Kelas AuthService bertanggung jawab untuk autentikasi: login, register, logout, dan menyimpan data user.
class AuthService {
  final String baseUrl =
      'https://teal-walrus-824468.hostingersite.com/api'; // Ganti dengan 127.0.0.1 jika bukan emulator Android

  /// Fungsi untuk login pengguna
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Kirim permintaan POST ke endpoint /login
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Accept': 'application/json',
        }, // Format response yang diterima
        body: {
          'email': email,
          'password': password,
        }, // Data login dikirim melalui body
      );

      // Decode response JSON
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Simpan data pengguna ke SharedPreferences jika login berhasil
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('role', data['user']['role']);
        await prefs.setString('name', data['user']['name']);
        await prefs.setString(
          'email',
          data['user']['email'],
        ); // Simpan email user
        await prefs.setString('id', data['user']['id']); // Simpan ID user

        return {'success': true, 'user': data['user']}; // Berhasil login
      } else {
        // Jika gagal login, tampilkan pesan dari server
        final message = data['message'] ?? 'Login gagal';
        print('⚠️ Login gagal: $message');
        return {'success': false, 'message': message};
      }
    } catch (e) {
      // Tangani error koneksi atau server
      print('❌ [ERROR LOGIN] $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan pada saat login. Pastikan server aktif.',
      };
    }
  }

  /// Fungsi untuk registrasi pengguna baru dengan data lengkap
  Future<Map<String, dynamic>> registerWithDetails({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
    required String gender,
  }) async {
    try {
      // Kirim permintaan POST ke endpoint /register
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

      // Decode response JSON
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Simpan data user ke SharedPreferences jika registrasi berhasil
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('role', data['user']['role']);
        await prefs.setString('name', data['user']['name']);
        await prefs.setString('id', data['user']['id'].toString());
        await prefs.setString('email', data['user']['email']);

        return {'success': true, 'user': data['user']};
      } else {
        // Jika gagal register
        final message = data['message'] ?? 'Register gagal';
        print('⚠️ Register gagal: $message');
        return {'success': false, 'message': message};
      }
    } catch (e) {
      // Tangani error
      print('❌ [ERROR REGISTER] $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan saat mendaftar. Coba lagi nanti.',
      };
    }
  }

  /// Fungsi untuk logout (menghapus semua data user dari SharedPreferences)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('id');
    print('👋 Logout: Token dan data user dihapus');
  }

  /// Mengecek apakah user sudah login (token tersimpan atau tidak)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  /// Mengambil token dari penyimpanan lokal
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Mengambil role user (misal: admin, user, dll)
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  /// Mengambil nama user dari penyimpanan lokal
  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  /// Mengambil informasi lengkap user: name, email, role, id
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
