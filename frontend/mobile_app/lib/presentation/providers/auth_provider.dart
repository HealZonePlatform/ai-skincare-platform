import 'dart:async';

import 'package:flutter/material.dart';

import 'package:ai_skincare_platform/core/analytics/analytics_service.dart';
import 'package:ai_skincare_platform/core/analytics/analytics_events.dart';
import 'package:ai_skincare_platform/core/demo/demo_session.dart';
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
  })  : _tokenRepository = tokenRepository ?? TokenRepositoryImpl(),
        _loginUseCase = loginUseCase ??
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
  final TokenRepository _tokenRepository;

  StreamSubscription<AuthSessionEvent>? _sessionSubscription;

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _initialize() async {
    await ApiClient.instance.init(tokenRepository: _tokenRepository);
    final tokens = await _checkAuthStatusUseCase.execute();
    if (tokens != null) {
      if (tokens.accessToken == DemoSession.tokens.accessToken) {
        DemoSession.activate();
      }
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  void _listenToSessionEvents() {
    _sessionSubscription = AuthSessionObserver.instance.events.listen((event) {
      if (event == AuthSessionEvent.signedOut) {
        _isLoggedIn = false;
        _errorMessage = 'Your session has expired. Please sign in again.';
        GlobalErrorNotifier.report(_errorMessage!);
        AnalyticsService.logEvent(
          AnalyticsEvent.authSessionTimeout,
          parameters: {'reason': 'refresh_failed'},
        );
        notifyListeners();
      }
    });
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credentials =
          UserCredentials.normalize(email: email, password: password);
      if (await _handleDemoLogin(credentials)) {
        return true;
      }
      await _loginUseCase.execute(credentials);
      _isLoggedIn = true;
      AnalyticsService.logEvent(
        AnalyticsEvent.authLoginSuccess,
        parameters: {'method': 'password'},
      );
      _notifySignedIn();
      return true;
    } catch (error, stackTrace) {
      ErrorHandler.logError(error, stackTrace);
      final normalized = ErrorHandler.normalize(error);
      final message = ErrorHandler.getUserMessage(normalized);
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
      AnalyticsService.logEvent(
        AnalyticsEvent.authRegisterSuccess,
        parameters: {'method': 'password'},
      );
      _notifySignedIn();
      return true;
    } catch (error, stackTrace) {
      ErrorHandler.logError(error, stackTrace);
      final normalized = ErrorHandler.normalize(error);
      final message = ErrorHandler.getUserMessage(normalized);
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
    DemoSession.deactivate();
    _isLoggedIn = false;
    AnalyticsService.logEvent(AnalyticsEvent.authLogout);
    AuthSessionObserver.instance.notify(AuthSessionEvent.signedOut);
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

  Future<bool> _handleDemoLogin(UserCredentials credentials) async {
    final inputEmail = credentials.email.toLowerCase();
    final inputPassword = credentials.password;

    final isDefaultDemo = inputEmail == DemoSession.demoEmail &&
        inputPassword == DemoSession.demoPassword;
    final isUserDemo = inputEmail == DemoSession.userDemoEmail &&
        inputPassword == DemoSession.userDemoPassword;

    if (!isDefaultDemo && !isUserDemo) {
      return false;
    }
    DemoSession.activate();
    await _tokenRepository.saveTokens(DemoSession.tokens);
    _isLoggedIn = true;
    AnalyticsService.logEvent(
      AnalyticsEvent.authDemoLogin,
      parameters: {'method': isDefaultDemo ? 'default_demo' : 'user_demo'},
    );
    _notifySignedIn();
    return true;
  }

  void _notifySignedIn() {
    AuthSessionObserver.instance.notify(AuthSessionEvent.signedIn);
  }
}
