// lib/domain/auth/usecases/register_usecase.dart

import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/auth_repository.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/token_repository.dart';

/// Registers a new account and persists the returned tokens.
class RegisterUseCase {
  final AuthRepository _authRepository;
  final TokenRepository _tokenRepository;

  const RegisterUseCase({
    required AuthRepository authRepository,
    required TokenRepository tokenRepository,
  })  : _authRepository = authRepository,
        _tokenRepository = tokenRepository;

  Future<AuthTokens> execute(Map<String, dynamic> payload) async {
    final tokens = await _authRepository.register(payload);
    await _tokenRepository.saveTokens(tokens);
    return tokens;
  }
}
