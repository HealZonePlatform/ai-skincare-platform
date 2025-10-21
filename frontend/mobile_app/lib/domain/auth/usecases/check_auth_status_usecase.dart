// lib/domain/auth/usecases/check_auth_status_usecase.dart

import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/token_repository.dart';

/// Determines whether valid tokens exist locally.
class CheckAuthStatusUseCase {
  final TokenRepository _tokenRepository;

  const CheckAuthStatusUseCase({
    required TokenRepository tokenRepository,
  }) : _tokenRepository = tokenRepository;

  Future<AuthTokens?> execute() {
    return _tokenRepository.fetchTokens();
  }
}
