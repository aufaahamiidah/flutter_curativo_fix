import 'package:flutter/material.dart';
import '/services/profile_service.dart';
import 'package:flutter_curativo/widgets/headers/profile_header.dart';
import 'package:flutter_curativo/widgets/cards/personal_info_card.dart';
import 'package:flutter_curativo/widgets/cards/profile_menu_card.dart';
import 'package:flutter_curativo/widgets/profile/logout_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final result = await ProfileService().getProfile();
    print('Profile result: $result');
    if (mounted) {
      setState(() {
        user = result['user'];
        isLoading = false;
      });
    }
  }

  Color getRandomColor(String? input) {
    if (input == null) return Colors.grey;
    final hash = input.codeUnits.fold(0, (prev, elem) => prev + elem);
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.brown,
      Colors.indigo,
      Colors.deepOrange,
      Colors.pink,
    ];
    return colors[hash % colors.length];
  }

  String getInitials(String? name) {
    if (name == null || name.isEmpty) return "?";
    List<String> parts = name.trim().split(" ");
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header dengan gradient overlay
                  ProfileHeader(
                    user: user,
                    getRandomColor: getRandomColor,
                    getInitials: getInitials,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Informasi Personal Card
                  PersonalInfoCard(user: user),
                  
                  const SizedBox(height: 20),
                  
                  // Menu Options
                  const ProfileMenuCard(),
                  
                  const SizedBox(height: 30),
                  
                  // Tombol Logout
                  const LogoutButton(),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const OptionButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFE53E3E),
          size: 24,
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF999999),
        ),
        onTap: onTap,
      ),
    );
  }
}
