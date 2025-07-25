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

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => isLoading = true);
    try {
      final data = await injuryService.fetchInjuryHistory();
      setState(() {
        scanHistory = data;
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
        _loadHistory(); // Refresh list
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

      _loadHistory();

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
    _loadHistory();
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
                onRefresh: _loadHistory,
                child:
                    scanHistory.isEmpty
                        ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 200),
                            Center(child: Text("Belum ada riwayat.")),
                          ],
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: scanHistory.length,
                          itemBuilder: (_, index) {
                            final item = scanHistory[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.blue.shade100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['label'] ?? '-',
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
    );
  }
}
