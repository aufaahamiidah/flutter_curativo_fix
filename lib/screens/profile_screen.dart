import 'package:flutter/material.dart';
import '/services/profile_service.dart';
import 'package:flutter_curativo/widgets/headers/profile_header.dart';
import 'package:flutter_curativo/widgets/cards/personal_info_card.dart';
import 'package:flutter_curativo/widgets/cards/profile_menu_card.dart';
import 'package:flutter_curativo/widgets/profile/logout_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;
  
  const ProfileScreen({super.key, this.onLanguageChanged});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  bool isLoading = true;
  String _currentLanguage = 'id';

  @override
  void initState() {
    super.initState();
    fetchProfile();
    _loadLanguage();
  }

  _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentLanguage = prefs.getString('language') ?? 'id';
    });
  }
  
  _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }

  Future<void> fetchProfile() async {
    final result = await ProfileService().getProfile();
    
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

  Widget _buildLanguageToggle() {
    return Positioned(
      top: 50,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('id', '🇮🇩'),
            _buildLanguageOption('en', '🇺🇸'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLanguageOption(String languageCode, String flag) {
    final isSelected = _currentLanguage == languageCode;
    
    return GestureDetector(
      onTap: () {
        if (languageCode != _currentLanguage) {
          setState(() {
            _currentLanguage = languageCode;
          });
          _saveLanguage(languageCode);
          if (widget.onLanguageChanged != null) {
            widget.onLanguageChanged!(Locale(languageCode));
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF000080) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 6),
            Text(
              languageCode.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF666666),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                RefreshIndicator(
                  onRefresh: fetchProfile,
                  color: const Color(0xFF000080),
                  backgroundColor: Colors.white,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        ProfileHeader(
                          user: user,
                          getRandomColor: getRandomColor,
                          getInitials: getInitials,
                        ),
                        
                        const SizedBox(height: 30),
                        PersonalInfoCard(user: user),
                        
                        const SizedBox(height: 20),
                        ProfileMenuCard(onLanguageChanged: null),
                        
                        const SizedBox(height: 30),
                        const LogoutButton(),
                        
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                _buildLanguageToggle(),
              ],
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
