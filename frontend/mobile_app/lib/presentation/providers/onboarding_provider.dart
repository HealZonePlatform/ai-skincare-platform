import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/config/onboarding_preferences.dart';

class OnboardingProvider with ChangeNotifier {
  OnboardingProvider({OnboardingPreferences? preferences})
      : _preferences = preferences;

  OnboardingPreferences? _preferences;
  bool _completed = false;

  bool get isCompleted => _completed;

  Future<void> load() async {
    _preferences ??= await OnboardingPreferences.create();
    _completed = _preferences!.isCompleted;
    notifyListeners();
  }

  Future<void> complete() async {
    _preferences ??= await OnboardingPreferences.create();
    await _preferences!.markCompleted();
    _completed = true;
    notifyListeners();
  }
}
