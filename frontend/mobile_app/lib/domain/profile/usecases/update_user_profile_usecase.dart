// lib/domain/profile/usecases/update_user_profile_usecase.dart

import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/domain/profile/repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository _repository;

  const UpdateUserProfileUseCase({
    required ProfileRepository repository,
  }) : _repository = repository;

  Future<UserProfile> execute(Map<String, dynamic> payload) {
    return _repository.updateProfile(payload);
  }
}
