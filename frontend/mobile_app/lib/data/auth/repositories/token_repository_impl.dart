// lib/data/auth/repositories/token_repository_impl.dart

import 'package:ai_skincare_platform/data/auth/datasources/token_local_data_source.dart';
import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/token_repository.dart';

class TokenRepositoryImpl implements TokenRepository {
  final TokenLocalDataSource _localDataSource;

  TokenRepositoryImpl({
    TokenLocalDataSource? localDataSource,
  }) : _localDataSource = localDataSource ?? TokenLocalDataSource();

  @override
  Future<void> clearTokens() {
    return _localDataSource.clearTokens();
  }

  @override
  Future<String?> fetchAccessToken() {
    return _localDataSource.fetchAccessToken();
  }

  @override
  Future<String?> fetchRefreshToken() {
    return _localDataSource.fetchRefreshToken();
  }

  @override
  Future<AuthTokens?> fetchTokens() {
    return _localDataSource.fetchTokens();
  }

  @override
  Future<void> saveTokens(AuthTokens tokens) {
    return _localDataSource.saveTokens(tokens);
  }
}
