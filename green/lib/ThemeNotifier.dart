import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  late ThemeData _themeData;
  final String _themePreferenceKey = 'theme_preference';

  ThemeNotifier() {
    _themeData = ThemeData.light();
    loadTheme();
  }

  ThemeData getTheme() => _themeData;

  void toggleTheme() {
    if (_themeData == ThemeData.light()) {
      _themeData = ThemeData.dark();
    } else {
      _themeData = ThemeData.light();
    }
    saveTheme();
    notifyListeners();
  }

  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themePreferenceKey, _themeData == ThemeData.dark());
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkTheme = prefs.getBool(_themePreferenceKey) ?? false;
    if (isDarkTheme) {
      _themeData = ThemeData.dark();
    } else {
      _themeData = ThemeData.light();
    }
    notifyListeners();
  }
}
