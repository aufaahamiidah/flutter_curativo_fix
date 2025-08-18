import 'dart:convert'; // Untuk konversi JSON
import 'package:http/http.dart' as http; // Untuk HTTP request (GET/POST)
import 'package:shared_preferences/shared_preferences.dart'; // Untuk ambil token & user ID dari penyimpanan lokal

/// Kelas ProfileService digunakan untuk mengambil data profil user dari server
class ProfileService {
  // Base URL dari API backend kamu
  final String baseUrl = 'https://teal-walrus-824468.hostingersite.com/api';

  /// Fungsi untuk mengambil data profil pengguna dari server
  Future<Map<String, dynamic>> getProfile() async {
    // Ambil data yang sudah disimpan saat login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // token otentikasi
    final id = prefs.getString('id'); // id user
    final role = prefs.getString('role') ?? 'user'; // role default = 'user'

    // Bentuk URL path: misal /admin/profile/5 atau /user/profile/5
    final path = '/$role/profile/$id';

    try {
      // Kirim request GET ke server
      final response = await http.get(
        Uri.parse('$baseUrl$path'), // contoh: https://.../user/profile/5
        headers: {
          'Authorization': 'Bearer $token', // sertakan token untuk akses
          'Accept': 'application/json', // minta response dalam format JSON
        },
      );

      // Jika response sukses (HTTP 200 OK)
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // decode JSON dari response

        // Cek apakah status dari API == true
        if (data['status'] == true) {
          return {
            'success': true,
            'user': data['data'], // data profil user dikembalikan di key 'data'
          };
        } else {
          // Jika status false → kirim pesan dari API
          return {
            'success': false,
            'message': data['message'] ?? 'Gagal ambil data',
          };
        }
      }
      // Jika akses ditolak karena hak akses (misal bukan admin)
      else if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Akses ditolak: Anda tidak berhak mengakses profil ini',
        };
      }
      // Jika token invalid atau expired (belum login)
      else if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Unauthorized: Silakan login ulang',
        };
      }
      // Jika status selain 200, 403, 401 → ambil pesan dari response
      else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Gagal ambil data',
        };
      }
    } catch (e) {
      // Jika terjadi error saat koneksi (tidak bisa terhubung ke server)
      return {'success': false, 'message': 'Terjadi kesalahan koneksi: $e'};
    }
  }
}
