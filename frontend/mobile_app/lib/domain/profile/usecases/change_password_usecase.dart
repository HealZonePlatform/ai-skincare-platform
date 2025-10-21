// lib/domain/profile/usecases/change_password_usecase.dart

import 'package:ai_skincare_platform/domain/profile/repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository _repository;

  const ChangePasswordUseCase({
    required ProfileRepository repository,
  }) : _repository = repository;

  Future<void> execute({
    required String currentPassword,
    required String newPassword,
  }) {
    return _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
