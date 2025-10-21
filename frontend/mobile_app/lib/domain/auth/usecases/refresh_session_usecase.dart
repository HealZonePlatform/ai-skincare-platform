// lib/domain/auth/usecases/refresh_session_usecase.dart

import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/auth_repository.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/token_repository.dart';

/// Refreshes the access token using the persisted refresh token.
class RefreshSessionUseCase {
  final AuthRepository _authRepository;
  final TokenRepository _tokenRepository;

  const RefreshSessionUseCase({
    required AuthRepository authRepository,
    required TokenRepository tokenRepository,
  })  : _authRepository = authRepository,
        _tokenRepository = tokenRepository;

  Future<AuthTokens?> execute() async {
    final refreshToken = await _tokenRepository.fetchRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final tokens = await _authRepository.refreshToken(refreshToken);
    await _tokenRepository.saveTokens(tokens);
    return tokens;
  }
}
