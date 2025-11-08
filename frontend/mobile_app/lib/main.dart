// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/error/global_error_notifier.dart';
import 'package:ai_skincare_platform/core/network/api_client.dart';
import 'package:ai_skincare_platform/l10n/app_localizations.dart';
import 'package:ai_skincare_platform/presentation/providers/auth_provider.dart';
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

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          final theme = AppTheme.build();
          final router = AppRouter(isLoggedIn: auth.isLoggedIn).router;
          return ValueListenableBuilder<String?>(
            valueListenable: GlobalErrorNotifier.notifier,
            child: MaterialApp.router(
              title: 'HealZone',
              debugShowCheckedModeBanner: false,
              theme: theme,
              routerConfig: router,
              scaffoldMessengerKey: _scaffoldMessengerKey,
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
            builder: (context, errorMessage, child) {
              Widget composed = Stack(alignment: Alignment.topLeft,
                children: [
                  child!,
                  AppLoadingOverlay(visible: auth.isLoading, message: 'Dang xac thuc phien lam viec...'),
                ],
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
              return composed;
            },
          );
        },
      ),
    );
  }
}

