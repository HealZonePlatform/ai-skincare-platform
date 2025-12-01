// lib/data/auth/datasources/token_local_data_source.dart

import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/core/security/secure_token_storage.dart';

/// Handles secure persistence of authentication tokens using [FlutterSecureStorage].
class TokenLocalDataSource {
  final SecureTokenStorage _storage;

  TokenLocalDataSource({
    SecureTokenStorage? storage,
  }) : _storage = storage ?? SecureTokenStorage();

  Future<void> saveTokens(AuthTokens tokens) async {
    await _storage.write(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
  }

  Future<AuthTokens?> fetchTokens() async {
    final values = await _storage.readTokens();
    final accessToken = values?['accessToken'];
    final refreshToken = values?['refreshToken'];

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<String?> fetchAccessToken() {
    return _storage.readAccessToken();
  }

  Future<String?> fetchRefreshToken() {
    return _storage.readRefreshToken();
  }

  Future<void> clearTokens() async {
    await _storage.clear();
  }
}
