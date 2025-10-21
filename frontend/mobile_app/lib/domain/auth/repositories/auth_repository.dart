// lib/domain/auth/repositories/auth_repository.dart

import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/auth/entities/user_credentials.dart';

/// Contract for authentication operations regardless of data source.
abstract class AuthRepository {
  Future<AuthTokens> login(UserCredentials credentials);

  Future<AuthTokens> register(Map<String, dynamic> payload);

  Future<AuthTokens> refreshToken(String refreshToken);
}
