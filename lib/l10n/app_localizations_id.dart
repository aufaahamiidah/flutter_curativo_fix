// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Curativo';

  @override
  String get homeTitle => 'Kit Darurat';

  @override
  String get firstAidTitle => 'Pertolongan Pertama';

  @override
  String get firstAidDescription => '🚑 Bantuan medis darurat.';

  @override
  String get checkConsciousness => 'Cek Kesadaran';

  @override
  String get checkConsciousnessDesc => 'Pastikan korban sadar.';

  @override
  String get callHelp => 'Hubungi Bantuan';

  @override
  String get callHelpDesc => 'Telepon 112/119.';

  @override
  String get minorWoundCare => 'P3K Luka Ringan';

  @override
  String get minorWoundDesc => '🩹 Perawatan luka kecil.';

  @override
  String get emergencyCPR => 'CPR Darurat';

  @override
  String get emergencyCPRDesc => '❤️ Bantuan hidup dasar.';

  @override
  String get firstAidEquipment => 'Perlengkapan P3K';

  @override
  String get firstAidEquipmentDesc =>
      'Perlengkapan pertolongan pertama dapat membantu kita ketika terjadi keadaan darurat.';

  @override
  String get welcome => 'Selamat Datang di Curativo';

  @override
  String get login => 'MASUK';

  @override
  String get register => 'DAFTAR';

  @override
  String get loginTitle => 'Masuk';

  @override
  String get registerTitle => 'Daftar';

  @override
  String get enterEmail => 'Masukkan email';

  @override
  String get enterPassword => 'Masukkan Password';

  @override
  String get enterFullName => 'Masukkan Nama Lengkap';

  @override
  String get enterPhoneNumber => 'Masukkan Nomor Telepon';

  @override
  String get confirmPassword => 'Konfirmasi Password';

  @override
  String get selectGender => 'Pilih Jenis Kelamin';

  @override
  String get male => 'Laki-laki';

  @override
  String get female => 'Perempuan';

  @override
  String get loading => 'Loading...';

  @override
  String get emailPasswordRequired => 'Email dan password harus diisi.';

  @override
  String get loginFailed =>
      'Login gagal. Periksa kembali email dan password Anda.';

  @override
  String get errorOccurred => 'Terjadi kesalahan';

  @override
  String get allFieldsRequired =>
      'Semua field harus diisi dan jenis kelamin harus dipilih.';

  @override
  String get passwordMismatch => 'Konfirmasi password tidak cocok.';

  @override
  String get registrationSuccess => 'Pendaftaran berhasil! Menuju Home Screen.';

  @override
  String get registrationFailed => 'Pendaftaran gagal.';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun?';

  @override
  String get dontHaveAccount => 'Belum punya akun?';

  @override
  String get home => 'Beranda';

  @override
  String get help => 'Bantuan';

  @override
  String get scan => 'Scan';

  @override
  String get history => 'Riwayat';

  @override
  String get account => 'Akun';

  @override
  String get profile => 'Profil';

  @override
  String get scanWound => 'Pindai Luka';

  @override
  String get uploadPhoto => 'Unggah Foto Luka';

  @override
  String get tapToSelectPhoto => 'Ketuk untuk memilih foto';

  @override
  String get ensureLighting => 'Pastikan pencahayaan cukup terang';

  @override
  String get focusCamera => 'Fokuskan kamera pada area luka';

  @override
  String get avoidShadows => 'Hindari bayangan pada foto';

  @override
  String get properDistance => 'Ambil foto dari jarak yang tepat';

  @override
  String get processing => 'MEMPROSES...';

  @override
  String get analyzingImage => 'Sedang menganalisis gambar...';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get errorOccurredWithDetails => '❌ Terjadi error';

  @override
  String get failedToTakePhoto => 'Gagal mengambil gambar';

  @override
  String get woundTypeBruise => 'Luka Lebam';

  @override
  String get woundTypeScratch => 'Luka Gores';

  @override
  String get woundTypeCut => 'Luka Sayat';

  @override
  String get woundTypeBurn => 'Luka Bakar';

  @override
  String get historySaved => 'Riwayat berhasil disimpan';

  @override
  String get failedToSaveHistory => 'Gagal menyimpan riwayat';

  @override
  String get saveToHistory => 'Simpan ke Riwayat';

  @override
  String get scanHistory => 'Riwayat Pindai';

  @override
  String get deleteAll => 'Hapus Semua';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteHistory => 'Hapus Riwayat';

  @override
  String get deleteAllHistory => 'Hapus Semua Riwayat';

  @override
  String get confirmDelete => 'Yakin ingin menghapus item ini?';

  @override
  String get confirmDeleteAll => 'Yakin ingin menghapus semua riwayat?';

  @override
  String get historyDeleted => 'Riwayat berhasil dihapus';

  @override
  String get allHistoryDeleted => 'Semua riwayat berhasil dihapus';

  @override
  String get someItemsFailedToDelete => 'Beberapa item gagal dihapus';

  @override
  String get failedToDelete => 'Gagal menghapus data';

  @override
  String get failedToLoadHistory => 'Gagal memuat riwayat';

  @override
  String get noScanHistory =>
      'Belum ada riwayat pindai.\nMulai pindai luka untuk melihat riwayat di sini.';

  @override
  String totalScanHistory(Object count) {
    return 'Total $count riwayat pindai';
  }

  @override
  String get unknown => 'Tidak diketahui';

  @override
  String get detail => 'Detail';

  @override
  String get detectionResult => 'Hasil Deteksi';

  @override
  String get detectionImage => 'Gambar Hasil Deteksi';

  @override
  String get detectedWoundType => 'Jenis Luka Terdeteksi';

  @override
  String get treatmentRecommendation => 'Rekomendasi Perawatan';

  @override
  String get confidenceLevel => 'Tingkat Keyakinan';

  @override
  String get accuracyLevel => 'Tingkat Akurasi';

  @override
  String get detectionAccuracy => 'Akurasi Deteksi';

  @override
  String get detectionTime => 'Waktu Deteksi';

  @override
  String get detailDetectionResult => 'Detail Hasil Deteksi';

  @override
  String get failedToLoadImage => 'Gagal memuat gambar';

  @override
  String get noImage => 'Tidak ada gambar';

  @override
  String get treatmentRecommendationTitle => 'Rekomendasi Penanganan';

  @override
  String get aboutApp => 'Tentang Aplikasi';

  @override
  String get appDescription =>
      'Aplikasi deteksi luka menggunakan AI untuk memberikan rekomendasi perawatan yang tepat';

  @override
  String get version => 'v1.0.0';

  @override
  String get mainFeatures => 'Fitur Utama';

  @override
  String get woundDetection => 'Deteksi Luka';

  @override
  String get woundDetectionDesc =>
      'Scan luka menggunakan kamera untuk identifikasi jenis luka';

  @override
  String get aiAnalysis => 'AI Analisis';

  @override
  String get aiAnalysisDesc => 'Teknologi AI canggih untuk analisis';

  @override
  String get treatmentRecommendationFeature => 'Rekomendasi Perawatan';

  @override
  String get treatmentRecommendationFeatureDesc =>
      'Saran perawatan berdasarkan jenis luka yang terdeteksi';

  @override
  String get scanHistoryFeature => 'Riwayat Pemindaian';

  @override
  String get scanHistoryFeatureDesc =>
      'Simpan dan lihat kembali hasil pemindaian sebelumnya';

  @override
  String get appInfo => 'Informasi Aplikasi';

  @override
  String get developmentTeam => 'Tim Pengembang';

  @override
  String get greenMonkeyTeam => 'GreenMonkey Team';

  @override
  String get support => 'Dukungan';

  @override
  String get supportDesc => 'Hubungi kami untuk bantuan dan saran';

  @override
  String get disclaimer => 'Disclaimer';

  @override
  String get disclaimerText =>
      'Aplikasi ini hanya untuk referensi. Selalu konsultasikan dengan tenaga medis profesional untuk diagnosis dan perawatan yang tepat.';

  @override
  String get giveHelp => 'Berikan Bantuan';

  @override
  String get emergencyFirstAidGuide => 'Panduan pertolongan pertama darurat';

  @override
  String get emergencyContact112 => 'Kontak Darurat 112';

  @override
  String get emergencyContactDesc => 'Hubungi layanan darurat Indonesia';

  @override
  String get emergencyGuide => 'Panduan Darurat';

  @override
  String get emergencySteps => 'Langkah-langkah pertolongan pertama';

  @override
  String get chokingAdult => 'Tersedak (Dewasa, Lansia)';

  @override
  String get chokingAdultDesc => 'Heimlich maneuver untuk dewasa';

  @override
  String get chokingAdultInstructions =>
      'Jika seseorang dewasa atau lansia tersedak dan masih bisa batuk atau bersuara, biarkan mereka batuk untuk mencoba mengeluarkan objek tersebut. Jika tidak bisa bernapas atau bicara, lakukan Heimlich maneuver.';

  @override
  String get chokingChild => 'Tersedak (Anak Kecil)';

  @override
  String get chokingChildDesc => 'Teknik khusus untuk anak-anak';

  @override
  String get chokingChildInstructions =>
      'Untuk anak kecil, posisikan mereka membungkuk ke depan dan tepuk punggung mereka lima kali dengan telapak tangan. Jika tidak berhasil, lakukan dorongan perut.';

  @override
  String get chokingBaby => 'Tersedak (Bayi)';

  @override
  String get chokingBabyDesc => 'Penanganan khusus untuk bayi';

  @override
  String get chokingBabyInstructions =>
      'Letakkan bayi telungkup di lengan Anda, kepala lebih rendah dari tubuh. Berikan lima tepukan di punggung, lalu lima tekanan dada jika belum berhasil.';

  @override
  String get severeBleeding => 'Pendarahan Parah';

  @override
  String get severeBleedingDesc => 'Cara menghentikan pendarahan';

  @override
  String get severeBleedingInstructions =>
      'Tekan langsung pada luka dengan kain bersih atau perban. Jika darah menembus, tambahkan lapisan lain tanpa melepas yang pertama. Angkat bagian yang berdarah lebih tinggi dari jantung jika memungkinkan.';

  @override
  String get heartAttack => 'Serangan Jantung';

  @override
  String get heartAttackDesc => 'Tanda dan penanganan darurat';

  @override
  String get heartAttackInstructions =>
      'Panggil bantuan medis segera. Berikan aspirin jika tersedia dan korban tidak alergi. Posisikan korban duduk dengan nyaman, longgarkan pakaian ketat.';

  @override
  String get stroke => 'Stroke';

  @override
  String get strokeDesc => 'Deteksi dini dan penanganan';

  @override
  String get strokeInstructions =>
      'Gunakan tes FAST: Face (wajah), Arms (lengan), Speech (bicara), Time (waktu). Jika ada tanda stroke, segera hubungi layanan darurat.';

  @override
  String get burns => 'Luka Bakar';

  @override
  String get burnsDesc => 'Penanganan luka bakar ringan hingga berat';

  @override
  String get burnsInstructions =>
      'Dinginkan luka bakar dengan air mengalir selama 10-20 menit. Jangan gunakan es. Tutup dengan kain bersih yang lembab. Untuk luka bakar parah, segera cari bantuan medis.';

  @override
  String get homeSubtitle => 'Solusi cerdas untuk perawatan luka';

  @override
  String get checkWoundCondition => 'Yuk, Cek\nKondisi Luka!';

  @override
  String get checkWoundSubtitle => 'Mari deteksi dan pantau luka sejak dini';

  @override
  String get emergencyKit => 'Kit Siaga';

  @override
  String get emergencyKitSubtitle => 'Pastikan kamu siap bantu penanganan luka';

  @override
  String get bruiseWound => 'Luka Lebam';

  @override
  String get scratchWound => 'Luka Gores';

  @override
  String get cutWound => 'Luka Sayat';

  @override
  String get burnWound => 'Luka Bakar';

  @override
  String get unknownWound => 'Tidak Diketahui';

  @override
  String get woundNotDetected => 'Luka tidak terdeteksi';

  @override
  String get failedToPickImage => 'Gagal mengambil gambar';

  @override
  String get scanInstruction1 => 'Pastikan pencahayaan cukup terang';

  @override
  String get scanInstruction2 => 'Fokuskan kamera pada area luka';

  @override
  String get scanInstruction3 => 'Hindari bayangan pada foto';

  @override
  String get scanInstruction4 => 'Ambil foto dari jarak yang tepat';

  @override
  String get bruiseRecommendation1 => 'Kompres dengan es selama 15-20 menit';

  @override
  String get bruiseRecommendation2 => 'Istirahatkan area yang terluka';

  @override
  String get bruiseRecommendation3 =>
      'Tinggikan bagian yang memar jika memungkinkan';

  @override
  String get bruiseRecommendation4 => 'Konsultasi dokter jika nyeri berlanjut';

  @override
  String get scratchRecommendation1 => 'Bersihkan luka dengan air bersih';

  @override
  String get scratchRecommendation2 => 'Oleskan antiseptik ringan';

  @override
  String get scratchRecommendation3 => 'Tutup dengan perban steril';

  @override
  String get scratchRecommendation4 => 'Ganti perban secara teratur';

  @override
  String get cutRecommendation1 => 'Hentikan pendarahan dengan menekan luka';

  @override
  String get cutRecommendation2 => 'Bersihkan luka dengan hati-hati';

  @override
  String get cutRecommendation3 => 'Oleskan salep antibiotik';

  @override
  String get cutRecommendation4 => 'Tutup dengan perban dan pantau infeksi';

  @override
  String get burnRecommendation1 => 'Dinginkan dengan air mengalir 10-20 menit';

  @override
  String get burnRecommendation2 => 'Jangan pecahkan lepuhan yang terbentuk';

  @override
  String get burnRecommendation3 =>
      'Oleskan gel lidah buaya atau krim luka bakar';

  @override
  String get burnRecommendation4 => 'Segera ke dokter jika luka bakar parah';

  @override
  String get indonesiaLanguage => '🇮🇩 Indonesia';

  @override
  String get englishLanguage => '🇺🇸 English';

  @override
  String get scanTips => 'Tips Pindai Luka';

  @override
  String get noRecommendationsAvailable => 'Tidak ada rekomendasi';

  @override
  String pageInfo(int currentPage, int lastPage) {
    return 'Halaman $currentPage dari $lastPage';
  }

  @override
  String get languageSettings => 'Bahasa / Language';

  @override
  String get personalInformation => 'Informasi Personal';

  @override
  String get fullName => 'Nama Lengkap';

  @override
  String get gender => 'Jenis Kelamin';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'No. Telepon';

  @override
  String get confidenceHigh => 'Tinggi';

  @override
  String get confidenceMedium => 'Sedang';

  @override
  String get confidenceLow => 'Rendah';

  @override
  String get kit => 'Kit';

  @override
  String get logout => 'LOGOUT';
}
