import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/services/injury_services.dart';
import 'detail_injury_screen.dart';
import '/widgets/cards/history_card.dart';
import '/widgets/navigation/pagination_controls.dart';
import '/widgets/lists/empty_state_widget.dart';
import '/widgets/common/custom_app_bar.dart';
import '../l10n/app_localizations.dart';

/// Halaman yang menampilkan riwayat pemindaian (scan history) cedera
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  // Instance dari service untuk mengambil data riwayat cedera (injury history)
  final injuryService = InjuryHistoryService();

  // List untuk menyimpan data riwayat scan yang diambil dari server
  List<dynamic> scanHistory = [];

  // Penanda apakah data sedang dimuat (loading)
  bool isLoading = true;

  // Status pagination
  int currentPage = 1;
  int lastPage = 1;
  int totalItems = 0;
  // Jumlah item per halaman
  final int perPage = 15;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memuat history ketika widget pertama kali dimunculkan
    _loadHistory();
  }

  /// Fungsi untuk mengambil data history dari server, dengan opsi memilih halaman
  Future<void> _loadHistory({int page = 1}) async {
    setState(() => isLoading = true);
    try {
      // Memanggil API dari service untuk mengambil data riwayat cedera
      final data = await injuryService.fetchInjuryHistory(page: page);
      setState(() {
        // Memperbarui data history dari response API
        scanHistory = data['items'];
        // Update status pagination berdasarkan response
        currentPage = data['pagination']['current_page'];
        lastPage = data['pagination']['last_page'];
        totalItems = data['pagination']['total'];
        isLoading = false;
      });
    } catch (e) {
      // Tangani jika terjadi error saat pengambilan data
      setState(() => isLoading = false);
      final localizations = AppLocalizations.of(context)!;
      _showErrorSnackBar(localizations.failedToLoadHistory);
    }
  }

  /// Fungsi untuk menghapus satu item history berdasarkan id
  Future<void> _deleteItem(String id) async {
    final localizations = AppLocalizations.of(context)!;
    // Tampilkan dialog konfirmasi penghapusan
    final confirm = await _showDeleteDialog(
      title: localizations.deleteHistory,
      content: localizations.confirmDelete,
    );

    // Jika pengguna mengkonfirmasi
    if (confirm == true) {
      final success = await injuryService.deleteInjuryHistory(id);
      if (success) {
        // Reload data history pada halaman saat ini
        _loadHistory(page: currentPage);
        _showSuccessSnackBar(localizations.historyDeleted);
      } else {
        _showErrorSnackBar(localizations.failedToDelete);
      }
    }
  }

  /// Fungsi untuk menghapus semua item yang tampil di halaman history
  Future<void> _deleteAllItems() async {
    final localizations = AppLocalizations.of(context)!;
    // Tampilkan dialog konfirmasi penghapusan seluruh data
    final confirm = await _showDeleteDialog(
      title: localizations.deleteAllHistory,
      content: localizations.confirmDeleteAll,
    );

    if (confirm == true) {
      bool allDeleted = true;
      // Menghapus masing-masing item dalam scanHistory secara berurutan
      for (var item in scanHistory) {
        final success = await injuryService.deleteInjuryHistory(
          item['id'].toString(),
        );
        // Tandai jika salah satu item gagal dihapus
        if (!success) allDeleted = false;
      }

      // Setelah proses penghapusan, muat ulang history dari halaman 1
      _loadHistory(page: 1);
      _showSuccessSnackBar(
        allDeleted
            ? localizations.allHistoryDeleted
            : localizations.someItemsFailedToDelete,
      );
    }
  }

  /// Menampilkan dialog konfirmasi penghapusan dengan judul dan isi pesan
  Future<bool?> _showDeleteDialog({
    required String title,
    required String content,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            // Bentuk dialog dengan sudut bundar
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: Text(content),
            actions: [
              // Tombol batal (cancel)
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(localizations.cancel),
              ),
              // Tombol hapus (delete)
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(localizations.delete),
              ),
            ],
          ),
    );
  }

  /// Menampilkan SnackBar dengan tampilan sukses
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Menampilkan SnackBar dengan tampilan error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Fungsi untuk memformat tanggal dari format ISO menjadi format lokal (hari, tanggal)
  String formatTanggal(String? iso, String locale) {
    if (iso == null || iso.isEmpty) return '-';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final hari = DateFormat('EEEE', locale).format(dt);
      final tanggal = DateFormat('dd/MM/yyyy HH:mm', locale).format(dt);
      return '$hari, $tanggal';
    } catch (e) {
      return '-';
    }
  }

  /// Fungsi untuk menyegarkan data history dengan memuat ulang halaman saat ini
  void refreshHistory() {
    _loadHistory(page: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Menentukan locale berdasarkan bahasa yang dipilih (id_ID untuk Indonesia, en_US untuk bahasa Inggris)
    final currentLocale = Localizations.localeOf(context);
    final localeString = currentLocale.languageCode == 'id' ? 'id_ID' : 'en_US';

    return Scaffold(
      // Menggunakan custom app bar dengan judul yang diambil dari localizations
      appBar: CustomAppBar(
        title: localizations.scanHistory,
        actions: [
          // Tampilkan tombol "delete all" hanya jika ada data scan history
          if (scanHistory.isNotEmpty)
            TextButton.icon(
              onPressed: _deleteAllItems,
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              label: Text(
                localizations.deleteAll,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      // Bagian body dengan background gradasi
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[50]!, Colors.white],
          ),
        ),
        // Tampilkan indikator loading bila data masih dimuat
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF000080),
                    ),
                  ),
                )
                // Jika tidak loading, maka tampilkan data dengan mekanisme RefreshIndicator
                : RefreshIndicator(
                  onRefresh: () => _loadHistory(page: currentPage),
                  color: const Color(0xFF000080),
                  child:
                      scanHistory.isEmpty
                          ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              const SizedBox(height: 100),
                              // Tampilan empty state jika tidak ada data history
                              EmptyStateWidget(
                                icon: Icons.history,
                                message: localizations.noScanHistory,
                              ),
                            ],
                          )
                          : Column(
                            children: [
                              // Bagian header untuk menampilkan informasi total data history
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF000080,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(
                                      0xFF000080,
                                    ).withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info_outline,
                                      color: Color(0xFF000080),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        // Tampilkan jumlah total scan history
                                        localizations.totalScanHistory(
                                          totalItems.toString(),
                                        ),
                                        style: const TextStyle(
                                          color: Color(0xFF000080),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Daftar riwayat scan ditampilkan dengan ListView.builder
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: scanHistory.length,
                                  itemBuilder: (context, index) {
                                    final item = scanHistory[index];
                                    // Menghitung index global pada data pagination
                                    final globalIndex =
                                        (currentPage - 1) * perPage + index + 1;

                                    return HistoryCard(
                                      title:
                                          item['label'] ??
                                          localizations.unknown,
                                      subtitle: formatTanggal(
                                        item['detected_at'],
                                        localeString,
                                      ),
                                      index: globalIndex,
                                      // Navigasi ke halaman detail untuk item scan history tertentu
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    DetailScreen(data: item),
                                          ),
                                        );
                                      },
                                      // Aksi tombol untuk setiap item, yaitu delete dan detail
                                      actions: [
                                        // Tombol delete untuk menghapus item
                                        TextButton.icon(
                                          onPressed:
                                              () => _deleteItem(
                                                item['id'].toString(),
                                              ),
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            size: 18,
                                            color: Colors.red,
                                          ),
                                          label: Text(
                                            localizations.delete,
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Tombol detail untuk melihat informasi lebih lengkap
                                        TextButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => DetailScreen(
                                                      data: item,
                                                    ),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.visibility_outlined,
                                            size: 18,
                                            color: Color(0xFF000080),
                                          ),
                                          label: Text(
                                            localizations.detail,
                                            style: const TextStyle(
                                              color: Color(0xFF000080),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              // Widget kontrol pagination di bawah daftar history
                              PaginationControls(
                                currentPage: currentPage,
                                lastPage: lastPage,
                                onPrevious:
                                    () => _loadHistory(page: currentPage - 1),
                                onNext:
                                    () => _loadHistory(page: currentPage + 1),
                              ),
                            ],
                          ),
                ),
      ),
    );
  }
}
