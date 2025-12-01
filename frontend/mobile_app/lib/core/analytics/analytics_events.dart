class AnalyticsEvent {
  const AnalyticsEvent._(
    this.name,
    this.category, {
    this.requiredParams = const [],
  });

  final String name;
  final String category;
  final List<String> requiredParams;

  static const screenView = AnalyticsEvent._(
    'screen_view',
    'engagement',
    requiredParams: ['screen'],
  );

  static const authLoginSuccess = AnalyticsEvent._(
    'auth_login_success',
    'auth',
    requiredParams: ['method'],
  );

  static const authRegisterSuccess = AnalyticsEvent._(
    'auth_register_success',
    'auth',
    requiredParams: ['method'],
  );

  static const authLogout = AnalyticsEvent._(
    'auth_logout',
    'auth',
  );

  static const authDemoLogin = AnalyticsEvent._(
    'auth_demo_login',
    'auth',
    requiredParams: ['method'],
  );

  static const authSessionTimeout = AnalyticsEvent._(
    'auth_session_timeout',
    'auth',
    requiredParams: ['reason'],
  );

  static const scanStarted = AnalyticsEvent._(
    'scan_started',
    'scan',
    requiredParams: ['source'],
  );

  static const scanCompleted = AnalyticsEvent._(
    'scan_completed',
    'scan',
    requiredParams: ['source'],
  );

  static const scanShared = AnalyticsEvent._(
    'scan_shared',
    'engagement',
    requiredParams: ['surface'],
  );

  static const contentArticleViewed = AnalyticsEvent._(
    'content_article_viewed',
    'engagement',
    requiredParams: ['id'],
  );

  static const productViewed = AnalyticsEvent._(
    'product_viewed',
    'engagement',
    requiredParams: ['id'],
  );

  static const routineOpened = AnalyticsEvent._(
    'routine_opened',
    'engagement',
    requiredParams: ['id'],
  );

  static const analysisHistoryOpened = AnalyticsEvent._(
    'analysis_history_opened',
    'engagement',
    requiredParams: ['id'],
  );

  static const buttonTap = AnalyticsEvent._(
    'ui_button_tap',
    'engagement',
    requiredParams: ['id'],
  );

  static const error = AnalyticsEvent._(
    'app_error',
    'error',
    requiredParams: ['message'],
  );
}
