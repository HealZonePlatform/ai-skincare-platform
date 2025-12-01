import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Simple local cache for persisting the last known dashboard payload
/// to support offline fallback.
class HomeLocalCache {
  static const _dashboardKey = 'cached_dashboard_payload';

  Future<void> saveDashboard(Map<String, dynamic> json) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dashboardKey, jsonEncode(json));
  }

  Future<Map<String, dynamic>?> readDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_dashboardKey);
    if (stored == null || stored.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(stored);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Ignore malformed cache and treat as missing.
    }
    return null;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_dashboardKey);
  }
}
