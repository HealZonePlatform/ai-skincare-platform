import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';

class ProfileLocalCache {
  ProfileLocalCache({SharedPreferences? preferences})
      : _preferencesFuture = preferences != null
            ? Future.value(preferences)
            : SharedPreferences.getInstance();

  static const _profileKey = 'cached_user_profile';
  static const _historyKey = 'cached_skin_history';

  final Future<SharedPreferences> _preferencesFuture;

  Future<void> cacheProfile(UserProfile profile) async {
    final prefs = await _preferencesFuture;
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<UserProfile?> readProfile() async {
    final prefs = await _preferencesFuture;
    final data = prefs.getString(_profileKey);
    if (data == null) return null;
    return UserProfile.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<void> cacheHistory(List<SkinAnalysisHistory> history) async {
    final prefs = await _preferencesFuture;
    final serialized = history.map((item) => item.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(serialized));
  }

  Future<List<SkinAnalysisHistory>> readHistory() async {
    final prefs = await _preferencesFuture;
    final data = prefs.getString(_historyKey);
    if (data == null) return [];
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded
        .map((item) => SkinAnalysisHistory.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
