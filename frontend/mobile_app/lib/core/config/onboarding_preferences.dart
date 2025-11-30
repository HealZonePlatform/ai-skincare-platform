import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPreferences {
  OnboardingPreferences._(this._prefs);

  final SharedPreferences _prefs;
  static const _keyCompleted = 'onboarding_completed';

  static Future<OnboardingPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return OnboardingPreferences._(prefs);
  }

  Future<void> markCompleted() async {
    await _prefs.setBool(_keyCompleted, true);
  }

  bool get isCompleted => _prefs.getBool(_keyCompleted) ?? false;
}
