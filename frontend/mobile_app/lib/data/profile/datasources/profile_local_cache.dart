import 'package:ai_skincare_platform/core/security/secure_preferences.dart';
import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';

class ProfileLocalCache {
  ProfileLocalCache({
    SecurePreferences? securePreferences,
  }) : _securePreferences = securePreferences ?? SecurePreferences();

  static const _profileKey = 'cached_user_profile';
  static const _historyKey = 'cached_skin_history';

  final SecurePreferences _securePreferences;

  Future<void> cacheProfile(UserProfile profile) async {
    await _securePreferences.saveJson(_profileKey, profile.toJson());
  }

  Future<UserProfile?> readProfile() async {
    final data = await _securePreferences.readJson(_profileKey);
    if (data == null) return null;
    return UserProfile.fromJson(data);
  }

  Future<void> cacheHistory(List<SkinAnalysisHistory> history) async {
    final serialized = history.map((item) => item.toJson()).toList();
    await _securePreferences.saveList(_historyKey, serialized);
  }

  Future<List<SkinAnalysisHistory>> readHistory() async {
    final data = await _securePreferences.readList(_historyKey);
    return data.map(SkinAnalysisHistory.fromJson).toList();
  }
}
