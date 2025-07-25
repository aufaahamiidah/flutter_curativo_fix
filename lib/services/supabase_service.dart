import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;

class SupabaseService {
  static const String supabaseUrl = 'https://vvbxfmihmfegaycbmeyb.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ2YnhmbWlobWZlZ2F5Y2JtZXliIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMzNDM4ODAsImV4cCI6MjA2ODkxOTg4MH0.9LtQfx7C3EDRnHiicBhl4opjU2xOtTp5puMD4e5qvME';
  static const String bucketName = 'curativo'; // Nama bucket untuk gambar luka

  static SupabaseClient get client => Supabase.instance.client;

  /// Inisialisasi Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  /// Upload gambar ke Supabase Storage
  static Future<String?> uploadImage({
    required File imageFile,
    required String fileName,
    String? folder,
  }) async {
    try {
      // Buat path file dengan folder jika ada
    final String filePath = folder != null ? '$folder/$fileName' : fileName;
    print('🔼 [Supabase] Uploading: $filePath');

    print('✅ [Supabase] Upload success. File path: $filePath');

      // Upload file ke Supabase Storage
      final response = await client.storage
          .from(bucketName)
          .upload(filePath, imageFile);

      // Dapatkan URL publik dari file yang diupload
      final String publicUrl = client.storage
          .from(bucketName)
          .getPublicUrl(filePath);

      print('🌐 [Supabase] Public URL: $publicUrl');

      return publicUrl;
    } catch (e) {
      print('❌ [Supabase] Error uploading image: $e');
      return null;
    }
  }

  /// Upload gambar dari bytes
  static Future<String?> uploadImageFromBytes({
    required Uint8List imageBytes,
    required String fileName,
    String? folder,
  }) async {
    try {
      final String filePath = folder != null 
          ? '$folder/$fileName'
          : fileName;

      final response = await client.storage
          .from(bucketName)
          .uploadBinary(filePath, imageBytes);

      final String publicUrl = client.storage
          .from(bucketName)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print('Error uploading image from bytes: $e');
      return null;
    }
  }

  /// Hapus gambar dari Supabase Storage
  static Future<bool> deleteImage(String filePath) async {
    try {
      await client.storage
          .from(bucketName)
          .remove([filePath]);
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Generate nama file unik
  static String generateFileName(String originalFileName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = path.extension(originalFileName);
    return 'injury_${timestamp}$extension';
  }

  /// Buat bucket jika belum ada
  static Future<bool> createBucketIfNotExists() async {
    try {
      // Cek apakah bucket sudah ada
      final buckets = await client.storage.listBuckets();
      final bucketExists = buckets.any((bucket) => bucket.name == bucketName);
      
      if (!bucketExists) {
        // Buat bucket baru
        await client.storage.createBucket(
          bucketName,
          BucketOptions(
            public: true,
            allowedMimeTypes: ['image/webp', 'image/jpeg', 'image/png','image/jpg'], // Ubah ke WebP saja
          ),
        );
      }
      return true;
    } catch (e) {
      print('Error creating bucket: $e');
      return false;
    }
  }
}