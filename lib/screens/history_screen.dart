import 'package:flutter/material.dart';
import 'package:flutter_curativo/screens/detail_injury_screen.dart';
import '/widgets/custom_bottom_navbar.dart';
import '/services/injury_services.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> scanHistory = [];
  bool isLoading = true;

  final injuryService = InjuryHistoryService();

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final data = await injuryService.fetchInjuryHistory();
      setState(() {
        scanHistory = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data: $e')));
    }
  }

  String formatTanggal(String isoDateString) {
    try {
      final dateTime = DateTime.parse(isoDateString).toLocal();
      final hari = DateFormat('EEEE', 'id_ID').format(dateTime);
      final tanggal = DateFormat('dd/MM/yyyy HH:mm', 'id_ID').format(dateTime);
      return '$hari, $tanggal';
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Pindai',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: implement delete all function
            },
            child: const Text(
              'Hapus Riwayat',
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : scanHistory.isEmpty
                ? const Center(child: Text("Belum ada riwayat."))
                : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: scanHistory.length,
                  itemBuilder: (context, index) {
                    final item = scanHistory[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blue.shade100),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['image'] ?? '',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 70,
                                    height: 70,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['label'] ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    formatTanggal(item['detected_at'] ?? ''),
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          // TODO: implement edit
                                        },
                                        child: const Text("Edit"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // TODO: implement delete
                                        },
                                        child: const Text("Hapus"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) =>
                                                      DetailScreen(data: item),
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
                            const Icon(
                              Icons.health_and_safety,
                              color: Colors.amber,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
      // bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }
}
