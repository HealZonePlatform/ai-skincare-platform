// lib/domain/auth/usecases/login_usecase.dart

import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/auth/entities/user_credentials.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/auth_repository.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/token_repository.dart';

/// Handles user authentication flow and persists tokens when successful.
class LoginUseCase {
  final AuthRepository _authRepository;
  final TokenRepository _tokenRepository;

  const LoginUseCase({
    required AuthRepository authRepository,
    required TokenRepository tokenRepository,
  })  : _authRepository = authRepository,
        _tokenRepository = tokenRepository;

  Future<AuthTokens> execute(UserCredentials credentials) async {
    final tokens = await _authRepository.login(credentials);
    await _tokenRepository.saveTokens(tokens);
    return tokens;
  }
}
