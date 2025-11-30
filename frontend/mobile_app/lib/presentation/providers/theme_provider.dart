import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/config/theme_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeProvider({
    ThemePreferences? preferences,
    ThemeMode initialMode = ThemeMode.system,
  })  : _preferences = preferences,
        _themeMode = initialMode {
    _hydrate();
  }

  ThemePreferences? _preferences;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  Future<void> _hydrate() async {
    _preferences ??= await ThemePreferences.create();
    final saved = _preferences!.getSavedThemeMode();
    if (saved != null && saved != _themeMode) {
      _themeMode = saved;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = _preferences ??= await ThemePreferences.create();
    await prefs.saveThemeMode(mode);
  }

  Future<void> toggle() async {
    final next =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }
}
