import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  ThemePreferences._(this._prefs);

  final SharedPreferences _prefs;
  static const _keyThemeMode = 'theme_mode';

  static Future<ThemePreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemePreferences._(prefs);
  }

  ThemeMode? getSavedThemeMode() {
    final storedIndex = _prefs.getInt(_keyThemeMode);
    if (storedIndex == null) return null;
    if (storedIndex < 0 || storedIndex >= ThemeMode.values.length) return null;
    return ThemeMode.values[storedIndex];
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setInt(_keyThemeMode, mode.index);
  }
}
