import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderPreferences {
  ReminderPreferences._(this._prefs);

  final SharedPreferences _prefs;

  static const _enabledKey = 'reminder_enabled';
  static const _hourKey = 'reminder_hour';
  static const _minuteKey = 'reminder_minute';

  static Future<ReminderPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ReminderPreferences._(prefs);
  }

  bool get isEnabled => _prefs.getBool(_enabledKey) ?? false;

  TimeOfDay get timeOfDay {
    final hour = _prefs.getInt(_hourKey) ?? 20;
    final minute = _prefs.getInt(_minuteKey) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> save({
    required bool enabled,
    required TimeOfDay time,
  }) async {
    await _prefs.setBool(_enabledKey, enabled);
    await _prefs.setInt(_hourKey, time.hour);
    await _prefs.setInt(_minuteKey, time.minute);
  }
}
