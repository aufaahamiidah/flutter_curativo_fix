import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';

class LanguageSwitcher extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  
  const LanguageSwitcher({Key? key, required this.onLanguageChanged}) : super(key: key);
  
  @override
  _LanguageSwitcherState createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends State<LanguageSwitcher> {
  String _currentLanguage = 'id';
  
  @override
  void initState() {
    super.initState();
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
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF000080).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption('id', '🇮🇩', localizations.indonesiaLanguage),
          _buildLanguageOption('en', '🇺🇸', localizations.englishLanguage),
        ],
      ),
    );
  }
  
  Widget _buildLanguageOption(String languageCode, String flag, String languageName) {
    final isSelected = _currentLanguage == languageCode;
    
    return GestureDetector(
      onTap: () {
        if (languageCode != _currentLanguage) {
          setState(() {
            _currentLanguage = languageCode;
          });
          _saveLanguage(languageCode);
          widget.onLanguageChanged(Locale(languageCode));
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
}