// lib/data/auth/repositories/auth_repository_impl.dart

import 'package:ai_skincare_platform/data/auth/datasources/auth_remote_data_source.dart';
import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/auth/entities/user_credentials.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    AuthRemoteDataSource? remoteDataSource,
  }) : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Future<AuthTokens> login(UserCredentials credentials) {
    return _remoteDataSource.login(credentials);
  }

  @override
  Future<AuthTokens> register(Map<String, dynamic> payload) {
    return _remoteDataSource.register(payload);
  }

  @override
  Future<AuthTokens> refreshToken(String refreshToken) {
    return _remoteDataSource.refresh(refreshToken);
  }
}
