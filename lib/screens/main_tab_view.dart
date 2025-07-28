import 'package:flutter/material.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';
import 'home_screen.dart';
import 'aid_screen.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainTabView extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;
  
  const MainTabView({super.key, this.onLanguageChanged});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _selectedIndex = 0;

  final GlobalKey<HistoryScreenState> _historyKey =
      GlobalKey<HistoryScreenState>();

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const AidScreen(),
      ScanScreen(
        onScanCompleted: () {
          _historyKey.currentState?.refreshHistory();
          setState(() {
            _selectedIndex = 3; // langsung ke Riwayat
          });
        },
      ),
      HistoryScreen(key: _historyKey),
      ProfileScreen(onLanguageChanged: widget.onLanguageChanged),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 156, 8, 0),
        unselectedItemColor: const Color(0xFF6D6D6D),
        backgroundColor: Colors.white,
        items: [
          _buildNavItem(Icons.home, localizations.home),
          _buildNavItem(Icons.medical_services, localizations.help),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF00009C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.qr_code_scanner, color: Colors.white),
                  const SizedBox(height: 4),
                  Text(
                    localizations.scan,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            label: ' ',
          ),
          _buildNavItem(Icons.history, localizations.history),
          _buildNavItem(Icons.person_outline, localizations.account),
        ],
      ),
    );
  }
}
