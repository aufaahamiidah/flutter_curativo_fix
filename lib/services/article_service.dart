import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ArticleService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<String> _getRolePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? 'user'; // default fallback
    return '/$role/articles';
  }

  // 🔹 Get all articles
  Future<List<dynamic>> getArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final path = await _getRolePath();

    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['articles'];
    } else {
      throw Exception('Gagal memuat artikel');
    }
  }

  // 🔹 Get detail article by ID
  Future<Map<String, dynamic>> getArticleDetail(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role') ?? 'user';
    final url = Uri.parse('$baseUrl/$role/articles/$id');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['article'];
    } else {
      throw Exception('Gagal memuat detail artikel');
    }
  }
}
