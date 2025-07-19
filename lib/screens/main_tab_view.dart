import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'aid_screen.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    AidScreen(),
    ScanScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

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
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF00009C),
        unselectedItemColor: const Color(0xFF6D6D6D),
        backgroundColor: Colors.white,
        items: [
          _buildNavItem(Icons.home, 'Beranda'),
          _buildNavItem(Icons.medical_services, 'Bantuan'),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF00009C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    'Scan',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            label: ' ',
          ),
          _buildNavItem(Icons.history, 'Riwayat'),
          _buildNavItem(Icons.person_outline, 'Akun'),
        ],
      ),
    );
  }
}
