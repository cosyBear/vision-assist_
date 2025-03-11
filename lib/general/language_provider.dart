import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('nl', 'NL'); // Default language: Dutch

  Locale get locale => _locale;

  LanguageProvider() {
    _loadSavedLanguage(); // ✅ Load language when app starts
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language');
    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners(); // ✅ Update UI with saved language
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', locale.languageCode);
    notifyListeners(); // ✅ Update UI after language change
  }
}
