// lib/domain/profile/repositories/profile_repository.dart

import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> fetchProfile();

  Future<UserProfile> updateProfile(Map<String, dynamic> payload);

  Future<List<SkinAnalysisHistory>> fetchAnalysisHistory({int page = 1, int pageSize = 10});

  Future<UserProfile> uploadAvatar(String filePath);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
