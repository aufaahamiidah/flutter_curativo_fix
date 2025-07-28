import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_curativo/l10n/app_localizations.dart';

class LanguageSwitcherToggle extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  
  const LanguageSwitcherToggle({Key? key, required this.onLanguageChanged}) : super(key: key);
  
  @override
  _LanguageSwitcherToggleState createState() => _LanguageSwitcherToggleState();
}

class _LanguageSwitcherToggleState extends State<LanguageSwitcherToggle> {
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _switchLanguage('id'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _currentLanguage == 'id' ? const Color(0xFF000080) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇮🇩', style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    'ID',
                    style: TextStyle(
                      color: _currentLanguage == 'id' ? Colors.white : const Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _switchLanguage('en'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _currentLanguage == 'en' ? const Color(0xFF000080) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇺🇸', style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(
                    'EN',
                    style: TextStyle(
                      color: _currentLanguage == 'en' ? Colors.white : const Color(0xFF666666),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _switchLanguage(String languageCode) {
    if (languageCode != _currentLanguage) {
      setState(() {
        _currentLanguage = languageCode;
      });
      _saveLanguage(languageCode);
      widget.onLanguageChanged(Locale(languageCode));
    }
  }
}