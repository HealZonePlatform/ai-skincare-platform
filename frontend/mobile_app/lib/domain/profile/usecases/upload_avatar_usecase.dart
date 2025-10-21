// lib/domain/profile/usecases/upload_avatar_usecase.dart

import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/domain/profile/repositories/profile_repository.dart';

class UploadAvatarUseCase {
  final ProfileRepository _repository;

  const UploadAvatarUseCase({
    required ProfileRepository repository,
  }) : _repository = repository;

  Future<UserProfile> execute(String filePath) {
    return _repository.uploadAvatar(filePath);
  }
}
