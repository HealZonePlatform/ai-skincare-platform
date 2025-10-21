// lib/domain/profile/usecases/get_user_profile_usecase.dart

import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/domain/profile/repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository _repository;

  const GetUserProfileUseCase({
    required ProfileRepository repository,
  }) : _repository = repository;

  Future<UserProfile> execute() {
    return _repository.fetchProfile();
  }
}
