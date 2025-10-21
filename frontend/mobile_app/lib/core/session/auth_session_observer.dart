// lib/core/session/auth_session_observer.dart

import 'dart:async';

enum AuthSessionEvent {
  signedOut,
}

class AuthSessionObserver {
  AuthSessionObserver._internal();

  static final AuthSessionObserver instance = AuthSessionObserver._internal();

  final StreamController<AuthSessionEvent> _controller =
      StreamController<AuthSessionEvent>.broadcast();

  Stream<AuthSessionEvent> get events => _controller.stream;

  void notify(AuthSessionEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void dispose() {
    _controller.close();
  }
}
