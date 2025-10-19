// Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:provider/provider.dart';

// Local imports
import 'package:ai_skincare_platform/providers/auth_provider.dart';
import 'package:ai_skincare_platform/router/app_router.dart';
import 'package:ai_skincare_platform/spec/spec_store.dart';
import 'package:ai_skincare_platform/utils/error_handler.dart';

void main() {
  // Setup global error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    ErrorHandler.logError(details.exception, details.stack);
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AuthProvider(),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final theme = _buildTheme();
          final router = AppRouter(isLoggedIn: auth.isLoggedIn).router;
          return MaterialApp.router(
            title: 'HealZone',
            debugShowCheckedModeBanner: false,
            theme: theme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}

ThemeData _buildTheme() {
  // Best-effort themed by tokens.json; falls back to defaults
  final tokens = SpecStore.instance.tokens;
  Color _c(String key, String fallback) {
    String hex = tokens?['colors']?[key] ?? fallback;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  final primary = _c('primary', '#8A8E5A');
  final secondary = _c('secondary', '#F4A259');
  final surface = _c('surface', '#FAF7F2');
  final textPrimary = _c('textPrimary', '#222222');
  // final textSecondary = _c('textSecondary', '#666666');

  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: primary).copyWith(
      primary: primary,
      secondary: secondary,
      surface: surface,
    ),
    scaffoldBackgroundColor: surface,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: surface,
      foregroundColor: textPrimary,
    ),
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: textPrimary,
      displayColor: textPrimary,
    ),
  );
}
