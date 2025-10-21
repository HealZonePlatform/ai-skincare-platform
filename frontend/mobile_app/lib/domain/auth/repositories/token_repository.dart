// lib/domain/auth/repositories/token_repository.dart

import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';

/// Abstraction for secure persistence of authentication tokens.
abstract class TokenRepository {
  Future<void> saveTokens(AuthTokens tokens);

  Future<AuthTokens?> fetchTokens();

  Future<String?> fetchAccessToken();

  Future<String?> fetchRefreshToken();

  Future<void> clearTokens();
}
