// import 'package:flutter/material.dart';
// import '/screens/home_screen.dart';
// import '/screens/aid_screen.dart';
// import '/screens/scan_screen.dart';
// import '/screens/history_screen.dart';
// import '/screens/profile_screen.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   final int currentIndex;

//   const CustomBottomNavBar({super.key, required this.currentIndex});

//   void _onItemTapped(BuildContext context, int index) {
//     if (index == currentIndex) return;

//     Widget targetPage;
//     switch (index) {
//       case 0:
//         targetPage = const HomeScreen();
//         break;
//       case 1:
//         targetPage = const AidScreen();
//         break;
//       case 2:
//         targetPage = const ScanScreen();
//         break;
//       case 3:
//         targetPage = const HistoryScreen();
//         break;
//       case 4:
//         targetPage = const ProfileScreen();
//         break;
//       default:
//         return;
//     }

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => targetPage),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: currentIndex,
//       onTap: (index) => _onItemTapped(context, index),
//       selectedItemColor: const Color(0xFF00009C),
//       unselectedItemColor: const Color(0xFF6D6D6D),
//       backgroundColor: Colors.white,
//       items: [
//         const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
//         const BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Bantuan'),
//         BottomNavigationBarItem(
//           icon: Container(
//             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//             decoration: BoxDecoration(
//               color: const Color(0xFF00009C),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.qr_code_scanner, color: Colors.white),
//                 SizedBox(height: 4),
//                 Text('Scan', style: TextStyle(color: Colors.white, fontSize: 12)),
//               ],
//             ),
//           ),
//           label: ' ',
//         ),
//         const BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
//         const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
//       ],
//     );
//   }
// }
