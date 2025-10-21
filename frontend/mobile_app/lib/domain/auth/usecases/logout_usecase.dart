// lib/domain/auth/usecases/logout_usecase.dart

import 'package:ai_skincare_platform/core/session/auth_session_observer.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/token_repository.dart';

/// Clears persisted auth tokens to sign the user out locally.
class LogoutUseCase {
  final TokenRepository _tokenRepository;

  const LogoutUseCase({
    required TokenRepository tokenRepository,
  }) : _tokenRepository = tokenRepository;

  Future<void> execute() async {
    await _tokenRepository.clearTokens();
    AuthSessionObserver.instance.notify(AuthSessionEvent.signedOut);
  }
}
