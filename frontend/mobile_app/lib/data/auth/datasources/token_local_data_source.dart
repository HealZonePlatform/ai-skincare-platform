// lib/data/auth/datasources/token_local_data_source.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';

/// Handles secure persistence of authentication tokens using [FlutterSecureStorage].
class TokenLocalDataSource {
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  final FlutterSecureStorage _storage;

  TokenLocalDataSource({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveTokens(AuthTokens tokens) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: tokens.accessToken),
      _storage.write(key: _refreshTokenKey, value: tokens.refreshToken),
    ]);
  }

  Future<AuthTokens?> fetchTokens() async {
    final values = await _storage.readAll();
    final accessToken = values[_accessTokenKey];
    final refreshToken = values[_refreshTokenKey];

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<String?> fetchAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> fetchRefreshToken() {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
