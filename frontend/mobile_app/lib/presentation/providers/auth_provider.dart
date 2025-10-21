import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/analytics/analytics_service.dart';
import 'package:ai_skincare_platform/core/error/global_error_notifier.dart';
import 'package:ai_skincare_platform/core/network/api_client.dart';
import 'package:ai_skincare_platform/core/session/auth_session_observer.dart';
import 'package:ai_skincare_platform/data/auth/repositories/auth_repository_impl.dart';
import 'package:ai_skincare_platform/data/auth/repositories/token_repository_impl.dart';
import 'package:ai_skincare_platform/domain/auth/entities/user_credentials.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/auth_repository.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/token_repository.dart';
import 'package:ai_skincare_platform/domain/auth/usecases/check_auth_status_usecase.dart';
import 'package:ai_skincare_platform/domain/auth/usecases/login_usecase.dart';
import 'package:ai_skincare_platform/domain/auth/usecases/logout_usecase.dart';
import 'package:ai_skincare_platform/domain/auth/usecases/register_usecase.dart';
import 'package:ai_skincare_platform/utils/error_handler.dart';

class AuthProvider with ChangeNotifier {
  AuthProvider({
    LoginUseCase? loginUseCase,
    RegisterUseCase? registerUseCase,
    LogoutUseCase? logoutUseCase,
    CheckAuthStatusUseCase? checkAuthStatusUseCase,
    AuthRepository? authRepository,
    TokenRepository? tokenRepository,
  })  : _loginUseCase = loginUseCase ??
            LoginUseCase(
              authRepository: authRepository ?? AuthRepositoryImpl(),
              tokenRepository: tokenRepository ?? TokenRepositoryImpl(),
            ),
        _registerUseCase = registerUseCase ??
            RegisterUseCase(
              authRepository: authRepository ?? AuthRepositoryImpl(),
              tokenRepository: tokenRepository ?? TokenRepositoryImpl(),
            ),
        _logoutUseCase = logoutUseCase ??
            LogoutUseCase(
              tokenRepository: tokenRepository ?? TokenRepositoryImpl(),
            ),
        _checkAuthStatusUseCase = checkAuthStatusUseCase ??
            CheckAuthStatusUseCase(
              tokenRepository: tokenRepository ?? TokenRepositoryImpl(),
            ) {
    _initialize();
    _listenToSessionEvents();
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  StreamSubscription<AuthSessionEvent>? _sessionSubscription;

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _initialize() async {
    await ApiClient.instance.init();
    final tokens = await _checkAuthStatusUseCase.execute();
    _isLoggedIn = tokens != null;
    notifyListeners();
  }

  void _listenToSessionEvents() {
    _sessionSubscription = AuthSessionObserver.instance.events.listen((event) {
      if (event == AuthSessionEvent.signedOut) {
        _isLoggedIn = false;
        _errorMessage = 'Your session has expired. Please sign in again.';
        GlobalErrorNotifier.report(_errorMessage!);
        notifyListeners();
      }
    });
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credentials = UserCredentials.normalize(email: email, password: password);
      await _loginUseCase.execute(credentials);
      _isLoggedIn = true;
      AnalyticsService.logEvent('login_success');
      return true;
    } catch (error, stackTrace) {
      ErrorHandler.logError(error, stackTrace);
      final message = ErrorHandler.getUserMessage(error);
      _errorMessage = message;
      GlobalErrorNotifier.report(message);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(Map<String, dynamic> userData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _registerUseCase.execute(userData);
      _isLoggedIn = true;
      AnalyticsService.logEvent('signup_success');
      return true;
    } catch (error, stackTrace) {
      ErrorHandler.logError(error, stackTrace);
      final message = ErrorHandler.getUserMessage(error);
      _errorMessage = message;
      GlobalErrorNotifier.report(message);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _logoutUseCase.execute();
    _isLoggedIn = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }
}
