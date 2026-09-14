# Curativo

<p align="center">
  <img src="screenshoot/Banner%20Curativo.png" alt="Banner Curativo" width="100%" />
</p>

## Tentang Aplikasi

**Curativo** adalah aplikasi mobile berbasis Flutter yang dilengkapi dengan kemampuan Machine Learning *on-device*. Aplikasi ini menggunakan TensorFlow Lite untuk memproses gambar dan memberikan hasil analisis, serta terintegrasi dengan **Supabase** sebagai backend.

### Fitur Utama:
- **Deteksi/Analisis Gambar**: Memanfaatkan model `best_float16.tflite` untuk melakukan deteksi langsung pada perangkat.
- **Kamera & Galeri**: Pengguna dapat mengambil gambar langsung melalui kamera atau memilih dari galeri.
- **Cloud Database**: Data disinkronisasi dan disimpan dengan aman menggunakan Supabase.
- **Desain Modern**: Antarmuka pengguna (UI) yang bersih dan intuitif dengan tipografi Poppins.

---

## Poster Aplikasi

<p align="center">
  <img src="screenshoot/Poster%20Curativo.png" alt="Poster Curativo" width="80%" />
</p>

---

## Cuplikan Layar (Screenshots)

Berikut adalah antarmuka aplikasi Curativo:

<p align="center">
  <img src="screenshoot/Curativo%201.jpeg" alt="Screenshot 1" width="30%" />
  <img src="screenshoot/Curativo%202.jpeg" alt="Screenshot 2" width="30%" />
  <img src="screenshoot/Curativo%203.jpeg" alt="Screenshot 3" width="30%" />
</p>
<p align="center">
  <img src="screenshoot/Curativo%204.jpeg" alt="Screenshot 4" width="30%" />
  <img src="screenshoot/Curativo%205.jpeg" alt="Screenshot 5" width="30%" />
  <img src="screenshoot/Curativo%206.jpeg" alt="Screenshot 6" width="30%" />
</p>

---

## Teknologi yang Digunakan

*   **Flutter**: Framework UI lintas platform dari Google.
*   **Supabase**: Pengganti Firebase sumber terbuka untuk basis data dan otentikasi.
*   **TensorFlow Lite (`tflite_flutter`)**: Menjalankan model AI secara *offline* di perangkat seluler.
*   **Image Picker & Image Compress**: Modul pemrosesan dan optimasi gambar.
*   **Google Fonts (Poppins)**: Tipografi modern.

---

## Cara Menjalankan

1. Pastikan Anda telah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Lakukan *clone* pada repositori ini.
3. Buka terminal di direktori proyek dan jalankan perintah berikut untuk mengunduh semua dependensi:
   ```bash
   flutter pub get
   ```
4. Hubungkan perangkat Android/iOS atau jalankan emulator.
5. Mulai aplikasi dengan:
   ```bash
   flutter run
   ```
