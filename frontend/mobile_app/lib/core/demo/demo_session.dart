// lib/core/demo/demo_session.dart
//
// NOTE: DemoSession is only for local UI testing. Remove before production release.

import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';

class DemoSession {
  DemoSession._();

  static const String demoEmail = 'demo@healzone.app';
  static const String demoPassword = 'Demo123';
  static const AuthTokens tokens = AuthTokens(
    accessToken: 'demo-access-token',
    refreshToken: 'demo-refresh-token',
  );

  static bool _active = false;
  static UserProfile _profile = _initialProfile;
  static List<SkinAnalysisHistory> _history = List.of(_initialHistory);

  static bool get isActive => _active;
  static UserProfile get profile => _profile;
  static List<SkinAnalysisHistory> get history => List.unmodifiable(_history);

  static void activate() {
    _active = true;
    _profile = _initialProfile;
    _history = List.of(_initialHistory);
  }

  static void deactivate() {
    _active = false;
  }

  static void updateProfile(UserProfile profile) {
    _profile = profile;
  }

  static void replaceHistory(List<SkinAnalysisHistory> entries) {
    _history = List.of(entries);
  }

  static final UserProfile _initialProfile = UserProfile(
    id: 'demo-user-001',
    email: demoEmail,
    fullName: 'Demo HealZone',
    phoneNumber: '+84 912 345 678',
    avatarUrl: null,
  );

  static final List<SkinAnalysisHistory> _initialHistory = [
    SkinAnalysisHistory(
      id: 'demo-analysis-01',
      userId: 'demo-user-001',
      imageUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
      analysisResult: const {
        'hydration': 82,
        'elasticity': 76,
        'oilControl': 61,
        'spots': 27,
      },
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: 'completed',
    ),
    SkinAnalysisHistory(
      id: 'demo-analysis-02',
      userId: 'demo-user-001',
      imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518',
      analysisResult: const {
        'hydration': 74,
        'elasticity': 69,
        'oilControl': 58,
        'spots': 35,
      },
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      status: 'completed',
    ),
  ];
}
