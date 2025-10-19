// Flutter imports
import 'package:flutter/material.dart';

// Package imports
import 'package:provider/provider.dart';

// Local imports
import 'package:ai_skincare_platform/providers/auth_provider.dart';
import 'package:ai_skincare_platform/router/app_router.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';
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
          final theme = AppTheme.build();
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
