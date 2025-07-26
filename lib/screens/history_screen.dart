import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/services/injury_services.dart';
import '/widgets/history_card.dart';
import '/widgets/pagination_controls.dart';
import '/widgets/empty_state_widget.dart';
import '/widgets/custom_app_bar.dart';
import 'detail_injury_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  final injuryService = InjuryHistoryService();
  List<dynamic> scanHistory = [];
  bool isLoading = true;

  // Pagination state
  int currentPage = 1;
  int lastPage = 1;
  int totalItems = 0;
  final int perPage = 15;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory({int page = 1}) async {
    setState(() => isLoading = true);
    try {
      final data = await injuryService.fetchInjuryHistory(page: page);
      setState(() {
        scanHistory = data['items'];
        currentPage = data['pagination']['current_page'];
        lastPage = data['pagination']['last_page'];
        totalItems = data['pagination']['total'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar('Gagal memuat riwayat');
    }
  }

  Future<void> _deleteItem(String id) async {
    final confirm = await _showDeleteDialog(
      title: "Hapus Riwayat",
      content: "Yakin ingin menghapus item ini?",
    );

    if (confirm == true) {
      final success = await injuryService.deleteInjuryHistory(id);
      if (success) {
        _loadHistory(page: currentPage);
        _showSuccessSnackBar("Riwayat berhasil dihapus");
      } else {
        _showErrorSnackBar("Gagal menghapus data");
      }
    }
  }

  Future<void> _deleteAllItems() async {
    final confirm = await _showDeleteDialog(
      title: "Hapus Semua Riwayat",
      content: "Yakin ingin menghapus semua riwayat?",
    );

    if (confirm == true) {
      bool allDeleted = true;
      for (var item in scanHistory) {
        final success = await injuryService.deleteInjuryHistory(
          item['id'].toString(),
        );
        if (!success) allDeleted = false;
      }

      _loadHistory(page: 1);
      _showSuccessSnackBar(
        allDeleted
            ? "Semua riwayat berhasil dihapus"
            : "Beberapa item gagal dihapus",
      );
    }
  }

  Future<bool?> _showDeleteDialog({
    required String title,
    required String content,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String formatTanggal(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final hari = DateFormat('EEEE', 'id_ID').format(dt);
      final tanggal = DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(dt);
      return '$hari, $tanggal';
    } catch (e) {
      return '-';
    }
  }

  void refreshHistory() {
    _loadHistory(page: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Riwayat Pindai',
        actions: [
          if (scanHistory.isNotEmpty)
            TextButton.icon(
              onPressed: _deleteAllItems,
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              label: const Text(
                'Hapus Semua',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50]!,
              Colors.white,
            ],
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF000080)),
                ),
              )
            : RefreshIndicator(
                onRefresh: () => _loadHistory(page: currentPage),
                color: const Color(0xFF000080),
                child: scanHistory.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 100),
                          EmptyStateWidget(
                            icon: Icons.history,
                            message: "Belum ada riwayat pindai.\nMulai pindai luka untuk melihat riwayat di sini.",
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          // Header info
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF000080).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF000080).withOpacity(0.2),
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
                                    'Total $totalItems riwayat pindai',
                                    style: const TextStyle(
                                      color: Color(0xFF000080),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // History list
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: scanHistory.length,
                              itemBuilder: (context, index) {
                                final item = scanHistory[index];
                                final globalIndex =
                                    (currentPage - 1) * perPage + index + 1;

                                return HistoryCard(
                                  title: item['label'] ?? 'Tidak diketahui',
                                  subtitle: formatTanggal(item['detected_at']),
                                  index: globalIndex,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                          data: item,
                                        ),
                                      ),
                                    );
                                  },
                                  actions: [
                                    TextButton.icon(
                                      onPressed: () => _deleteItem(
                                        item['id'].toString(),
                                      ),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      label: const Text(
                                        "Hapus",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
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
                                      label: const Text(
                                        "Detail",
                                        style: TextStyle(
                                          color: Color(0xFF000080),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          // Pagination
                          PaginationControls(
                            currentPage: currentPage,
                            lastPage: lastPage,
                            onPrevious: () => _loadHistory(page: currentPage - 1),
                            onNext: () => _loadHistory(page: currentPage + 1),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }
}
