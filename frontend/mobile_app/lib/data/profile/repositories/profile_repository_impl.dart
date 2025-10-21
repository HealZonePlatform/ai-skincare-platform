// lib/data/profile/repositories/profile_repository_impl.dart

import 'package:ai_skincare_platform/data/profile/datasources/profile_remote_data_source.dart';
import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/domain/profile/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({
    ProfileRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? ProfileRemoteDataSource();

  @override
  Future<UserProfile> fetchProfile() {
    return _remoteDataSource.fetchProfile();
  }

  @override
  Future<List<SkinAnalysisHistory>> fetchAnalysisHistory({
    int page = 1,
    int pageSize = 10,
  }) {
    return _remoteDataSource.fetchAnalysisHistory(
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> payload) {
    return _remoteDataSource.updateProfile(payload);
  }

  @override
  Future<UserProfile> uploadAvatar(String filePath) {
    return _remoteDataSource.uploadAvatar(filePath);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
