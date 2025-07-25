import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/services/injury_services.dart';
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
    }
  }

  Future<void> _deleteItem(String id) async {
    final confirm = await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Hapus Riwayat"),
            content: const Text("Yakin ingin menghapus item ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Hapus"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final success = await injuryService.deleteInjuryHistory(id);
      if (success) {
        _loadHistory(page: currentPage); // Tetap di halaman yang sama
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Riwayat berhasil dihapus")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal menghapus data")));
      }
    }
  }

  Future<void> _deleteAllItems() async {
    final confirm = await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Hapus Semua Riwayat"),
            content: const Text("Yakin ingin menghapus semua riwayat?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Hapus Semua"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      bool allDeleted = true;
      for (var item in scanHistory) {
        final success = await injuryService.deleteInjuryHistory(
          item['id'].toString(),
        );
        if (!success) allDeleted = false;
      }

      _loadHistory(page: 1); // Kembali ke halaman 1

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            allDeleted
                ? "Semua riwayat berhasil dihapus"
                : "Beberapa item gagal dihapus",
          ),
        ),
      );
    }
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
      appBar: AppBar(
        title: const Text(
          'Riwayat Pindai',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (scanHistory.isNotEmpty)
            TextButton(
              onPressed: _deleteAllItems,
              child: const Text(
                'Hapus Semua',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () => _loadHistory(page: currentPage),
                child:
                    scanHistory.isEmpty
                        ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 200),
                            Center(child: Text("Belum ada riwayat.")),
                          ],
                        )
                        : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.all(12),
                                itemCount: scanHistory.length,
                                itemBuilder: (_, index) {
                                  final item = scanHistory[index];
                                  final globalIndex =
                                      (currentPage - 1) * perPage + index + 1;

                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: Colors.blue.shade100,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "$globalIndex. ${item['label'] ?? '-'}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            formatTanggal(item['detected_at']),
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed:
                                                    () => _deleteItem(
                                                      item['id'].toString(),
                                                    ),
                                                child: const Text("Hapus"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (_) => DetailScreen(
                                                            data: item,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: const Text("Detail"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (lastPage > 1)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed:
                                          currentPage > 1
                                              ? () => _loadHistory(
                                                page: currentPage - 1,
                                              )
                                              : null,
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(12),
                                      ),
                                      child: const Icon(Icons.chevron_left),
                                    ),
                                    const SizedBox(width: 16),
                                    Text('Halaman $currentPage dari $lastPage'),
                                    const SizedBox(width: 16),
                                    ElevatedButton(
                                      onPressed:
                                          currentPage < lastPage
                                              ? () => _loadHistory(
                                                page: currentPage + 1,
                                              )
                                              : null,
                                      style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(),
                                        padding: const EdgeInsets.all(12),
                                      ),
                                      child: const Icon(Icons.chevron_right),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
              ),
    );
  }
}
