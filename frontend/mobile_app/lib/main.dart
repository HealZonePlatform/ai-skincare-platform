// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/error/global_error_notifier.dart';
import 'package:ai_skincare_platform/core/network/api_client.dart';
import 'package:ai_skincare_platform/l10n/app_localizations.dart';
import 'package:ai_skincare_platform/presentation/providers/auth_provider.dart';
import 'package:ai_skincare_platform/presentation/providers/home_provider.dart';
import 'package:ai_skincare_platform/presentation/providers/onboarding_provider.dart';
import 'package:ai_skincare_platform/presentation/providers/theme_provider.dart';
import 'package:ai_skincare_platform/presentation/providers/user_profile_provider.dart';
import 'package:ai_skincare_platform/presentation/router/app_router.dart';
import 'package:ai_skincare_platform/presentation/widgets/app_loading_overlay.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';
import 'package:ai_skincare_platform/utils/error_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.instance.init();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    ErrorHandler.logError(details.exception, details.stack);
  };

  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()..load()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: Consumer3<AuthProvider, ThemeProvider, OnboardingProvider>(
        builder: (context, auth, themeProvider, onboardingProvider, _) {
          final router = AppRouter(
            isLoggedIn: auth.isLoggedIn,
            onboardingCompleted: onboardingProvider.isCompleted,
          ).router;
          return ValueListenableBuilder<String?>(
            valueListenable: GlobalErrorNotifier.notifier,
            builder: (context, errorMessage, _) {
              return MaterialApp.router(
                title: 'HealZone',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.build(),
                darkTheme: AppTheme.build(isDark: true),
                themeMode: themeProvider.themeMode,
                routerConfig: router,
                scaffoldMessengerKey: _scaffoldMessengerKey,
                localizationsDelegates: const [
                  AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) {
                  final overlay = AppLoadingOverlay(
                    visible: auth.isLoading,
                    message: 'Đang xác thực phiên làm việc...',
                  );
                  if (errorMessage != null && errorMessage.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final messenger = _scaffoldMessengerKey.currentState;
                      if (messenger != null) {
                        messenger
                          ..removeCurrentSnackBar()
                          ..showSnackBar(SnackBar(content: Text(errorMessage)));
                      }
                      GlobalErrorNotifier.clear();
                    });
                  }
                  return Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      if (child != null) child,
                      overlay,
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
