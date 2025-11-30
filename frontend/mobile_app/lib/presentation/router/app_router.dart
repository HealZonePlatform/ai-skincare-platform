import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/presentation/providers/user_profile_provider.dart';
import 'package:ai_skincare_platform/presentation/router/router_observer.dart';
import 'package:ai_skincare_platform/presentation/screens/advice/advice_screen.dart';
import 'package:ai_skincare_platform/presentation/screens/auth/login_screen.dart';
import 'package:ai_skincare_platform/presentation/screens/auth/register_screen.dart';
import 'package:ai_skincare_platform/presentation/screens/checkout/checkout_screens.dart';
import 'package:ai_skincare_platform/presentation/screens/community/community_screens.dart';
import 'package:ai_skincare_platform/presentation/screens/history/history_screen.dart';
import 'package:ai_skincare_platform/presentation/screens/home/home_screen.dart';
import 'package:ai_skincare_platform/presentation/screens/lifestyle/lifestyle_screen.dart';
import 'package:ai_skincare_platform/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:ai_skincare_platform/presentation/screens/paywall/paywall_screen.dart';
import 'package:ai_skincare_platform/presentation/screens/products/products_screens.dart';
import 'package:ai_skincare_platform/presentation/screens/profile/profile_screens.dart';
import 'package:ai_skincare_platform/presentation/screens/profile/skin_analysis_detail_screen.dart';
import 'package:ai_skincare_platform/presentation/screens/routine/routine_screen.dart';
import 'package:ai_skincare_platform/presentation/screens/scan/scan_screens.dart';
import 'package:ai_skincare_platform/presentation/screens/survey/survey_screens.dart';
import 'package:ai_skincare_platform/presentation/widgets/shell_scaffold.dart';

class AppRouter {
  AppRouter({required this.isLoggedIn, required this.onboardingCompleted});

  final bool isLoggedIn;
  final bool onboardingCompleted;

  GoRouter get router => _router;

  late final GoRouter _router = GoRouter(
    observers: [AnalyticsRouterObserver()],
    initialLocation: onboardingCompleted
        ? (isLoggedIn ? '/home' : '/auth/signin')
        : '/onboarding',
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
              path: '/home', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/community',
            builder: (context, state) => const CommunityFeedScreen(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (context, state) => CommunityDetailScreen(
                    postId: state.pathParameters['id'] ?? ''),
              ),
              GoRoute(
                  path: 'new',
                  builder: (context, state) => const CommunityNewPostScreen()),
            ],
          ),
          GoRoute(
              path: '/history',
              builder: (context, state) => const HistoryScreen()),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileOverviewScreen(),
            routes: [
              GoRoute(
                  path: 'reminders',
                  builder: (context, state) => const ProfileRemindersScreen()),
              GoRoute(
                  path: 'goals',
                  builder: (context, state) => const ProfileGoalsScreen()),
              GoRoute(
                  path: 'basic',
                  builder: (context, state) => const ProfileBasicScreen()),
              GoRoute(
                path: 'analysis/:id',
                name: 'analysis-detail',
                builder: (context, state) {
                  final analysis = state.extra as SkinAnalysisHistory?;
                  if (analysis != null) {
                    return SkinAnalysisDetailScreen(analysisItem: analysis);
                  }

                  final id = state.pathParameters['id'];
                  if (id == null) {
                    return const Scaffold(
                      body:
                          Center(child: Text('Analysis result not available.')),
                    );
                  }

                  final provider =
                      Provider.of<UserProfileProvider>(context, listen: false);
                  final fallback = provider.skinAnalysisHistory.firstWhere(
                    (item) => item.id == id,
                    orElse: () => provider.skinAnalysisHistory.isNotEmpty
                        ? provider.skinAnalysisHistory.first
                        : throw StateError('Analysis $id not found'),
                  );
                  return SkinAnalysisDetailScreen(analysisItem: fallback);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
      GoRoute(
          path: '/preferences/categories',
          builder: (c, s) => const PreferencesCategoriesScreen()),
      GoRoute(path: '/auth/signup', builder: (c, s) => const RegisterScreen()),
      GoRoute(path: '/auth/signin', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/auth/sigin', builder: (c, s) => const LoginScreen()),
      GoRoute(
          path: '/survey/skin-type',
          builder: (c, s) => const SurveySkinTypeScreen()),
      GoRoute(
          path: '/survey/concerns',
          builder: (c, s) => const SurveyConcernsScreen()),
      GoRoute(
          path: '/scan/prepare', builder: (c, s) => const ScanPrepareScreen()),
      GoRoute(
          path: '/scan/capture', builder: (c, s) => const ScanCaptureScreen()),
      GoRoute(
          path: '/scan/result', builder: (c, s) => const ScanResultScreen()),
      GoRoute(path: '/advice', builder: (c, s) => const AdviceScreen()),
      GoRoute(path: '/routine', builder: (c, s) => const RoutineScreen()),
      GoRoute(path: '/products', builder: (c, s) => const ProductsListScreen()),
      GoRoute(
        path: '/products/:id',
        builder: (c, s) =>
            ProductDetailScreen(productId: s.pathParameters['id'] ?? ''),
      ),
      GoRoute(path: '/lifestyle', builder: (c, s) => const LifestyleScreen()),
      GoRoute(path: '/paywall', builder: (c, s) => const PaywallScreen()),
      GoRoute(
          path: '/checkout/method',
          builder: (c, s) => const CheckoutMethodScreen()),
      GoRoute(
          path: '/checkout/card',
          builder: (c, s) => const CheckoutCardScreen()),
      GoRoute(
          path: '/checkout/qr', builder: (c, s) => const CheckoutQrScreen()),
      GoRoute(
          path: '/checkout/success',
          builder: (c, s) => const CheckoutSuccessScreen()),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(child: Text('No route for ${state.uri}')),
    ),
    redirect: (context, state) {
      final goingAuth = state.matchedLocation.startsWith('/auth/');
      final onboardingFlow = state.matchedLocation.startsWith('/onboarding') ||
          state.matchedLocation.startsWith('/preferences') ||
          state.matchedLocation.startsWith('/survey');

      if (!onboardingCompleted && !onboardingFlow) {
        return '/onboarding';
      }

      if (!isLoggedIn && !goingAuth && onboardingCompleted) {
        return '/auth/signin';
      }
      return null;
    },
  );
}
