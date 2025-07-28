import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/services/injury_services.dart';
import 'detail_injury_screen.dart';
import '/widgets/cards/history_card.dart';
import '/widgets/navigation/pagination_controls.dart';
import '/widgets/lists/empty_state_widget.dart';
import '/widgets/common/custom_app_bar.dart';
import '../l10n/app_localizations.dart';

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
      final localizations = AppLocalizations.of(context)!;
      _showErrorSnackBar(localizations.failedToLoadHistory);
    }
  }

  Future<void> _deleteItem(String id) async {
    final localizations = AppLocalizations.of(context)!;
    final confirm = await _showDeleteDialog(
      title: localizations.deleteHistory,
      content: localizations.confirmDelete,
    );

    if (confirm == true) {
      final success = await injuryService.deleteInjuryHistory(id);
      if (success) {
        _loadHistory(page: currentPage);
        _showSuccessSnackBar(localizations.historyDeleted);
      } else {
        _showErrorSnackBar(localizations.failedToDelete);
      }
    }
  }

  Future<void> _deleteAllItems() async {
    final localizations = AppLocalizations.of(context)!;
    final confirm = await _showDeleteDialog(
      title: localizations.deleteAllHistory,
      content: localizations.confirmDeleteAll,
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
            ? localizations.allHistoryDeleted
            : localizations.someItemsFailedToDelete,
      );
    }
  }

  Future<bool?> _showDeleteDialog({
    required String title,
    required String content,
  }) {
    final localizations = AppLocalizations.of(context)!;
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
            child: Text(localizations.cancel),
          ),
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

  void refreshHistory() {
    _loadHistory(page: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    // Tentukan locale berdasarkan bahasa yang dipilih
    final currentLocale = Localizations.localeOf(context);
    final localeString = currentLocale.languageCode == 'id' ? 'id_ID' : 'en_US';
    
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.scanHistory,
        actions: [
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
                        children: [
                          const SizedBox(height: 100),
                          EmptyStateWidget(
                            icon: Icons.history,
                            message: localizations.noScanHistory,
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
                                    localizations.totalScanHistory(totalItems.toString()),
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
                                  title: item['label'] ?? localizations.unknown,
                                  subtitle: formatTanggal(item['detected_at'], localeString),
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
                                      label: Text(
                                        localizations.delete,
                                        style: const TextStyle(color: Colors.red),
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
