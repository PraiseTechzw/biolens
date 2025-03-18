import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  bool _isDarkMode = false;
  String _language = 'en';
  bool _isFirstLaunch = true;

  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  bool get isFirstLaunch => _isFirstLaunch;

  AppProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _language = prefs.getString('language') ?? 'en';
    _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    notifyListeners();
  }

  Future<void> setFirstLaunch(bool value) async {
    _isFirstLaunch = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', value);
    notifyListeners();
  }
} 