import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_skincare_platform/screens/advice/advice_screen.dart';
import 'package:ai_skincare_platform/screens/auth/login_screen.dart';
import 'package:ai_skincare_platform/screens/auth/register_screen.dart';
import 'package:ai_skincare_platform/screens/checkout/checkout_screens.dart';
import 'package:ai_skincare_platform/screens/community/community_screens.dart';
import 'package:ai_skincare_platform/screens/history/history_screen.dart';
import 'package:ai_skincare_platform/screens/home_screen.dart';
import 'package:ai_skincare_platform/screens/lifestyle/lifestyle_screen.dart';
import 'package:ai_skincare_platform/screens/onboarding/onboarding_screen.dart';
import 'package:ai_skincare_platform/screens/paywall/paywall_screen.dart';
import 'package:ai_skincare_platform/screens/products/products_screens.dart';
import 'package:ai_skincare_platform/screens/profile/profile_screens.dart';
import 'package:ai_skincare_platform/screens/routine/routine_screen.dart';
import 'package:ai_skincare_platform/screens/scan/scan_screens.dart';
import 'package:ai_skincare_platform/screens/survey/survey_screens.dart';
import 'package:ai_skincare_platform/widgets/shell_scaffold.dart';

class AppRouter {
  AppRouter({required this.isLoggedIn});
  final bool isLoggedIn;

  GoRouter get router => _router;

  late final GoRouter _router = GoRouter(
    initialLocation: isLoggedIn ? '/home' : '/auth/signin',
    routes: [
      ShellRoute(
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/community',
            builder: (context, state) => const CommunityFeedScreen(),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (context, state) => CommunityDetailScreen(postId: state.pathParameters['id'] ?? ''),
              ),
              GoRoute(
                path: 'new',
                builder: (context, state) => const CommunityNewPostScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileOverviewScreen(),
            routes: [
              GoRoute(
                path: 'reminders',
                builder: (context, state) => const ProfileRemindersScreen(),
              ),
              GoRoute(
                path: 'goals',
                builder: (context, state) => const ProfileGoalsScreen(),
              ),
              GoRoute(
                path: 'basic',
                builder: (context, state) => const ProfileBasicScreen(),
              ),
            ],
          ),
        ],
      ),

      // Auth + onboarding flows
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
      GoRoute(path: '/preferences/categories', builder: (c, s) => const PreferencesCategoriesScreen()),
      GoRoute(path: '/auth/signup', builder: (c, s) => const RegisterScreen()),
      GoRoute(path: '/auth/signin', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/auth/sigin', builder: (c, s) => const LoginScreen()),

      // Survey
      GoRoute(path: '/survey/skin-type', builder: (c, s) => const SurveySkinTypeScreen()),
      GoRoute(path: '/survey/concerns', builder: (c, s) => const SurveyConcernsScreen()),

      // Scan flow + advice + routine
      GoRoute(path: '/scan/prepare', builder: (c, s) => const ScanPrepareScreen()),
      GoRoute(path: '/scan/capture', builder: (c, s) => const ScanCaptureScreen()),
      GoRoute(path: '/scan/result', builder: (c, s) => const ScanResultScreen()),
      GoRoute(path: '/advice', builder: (c, s) => const AdviceScreen()),
      GoRoute(path: '/routine', builder: (c, s) => const RoutineScreen()),

      // Products
      GoRoute(path: '/products', builder: (c, s) => const ProductsListScreen()),
      GoRoute(
        path: '/products/:id',
        builder: (c, s) => ProductDetailScreen(productId: s.pathParameters['id'] ?? ''),
      ),

      // Lifestyle
      GoRoute(path: '/lifestyle', builder: (c, s) => const LifestyleScreen()),

      // Paywall + checkout
      GoRoute(path: '/paywall', builder: (c, s) => const PaywallScreen()),
      GoRoute(path: '/checkout/method', builder: (c, s) => const CheckoutMethodScreen()),
      GoRoute(path: '/checkout/card', builder: (c, s) => const CheckoutCardScreen()),
      GoRoute(path: '/checkout/qr', builder: (c, s) => const CheckoutQrScreen()),
      GoRoute(path: '/checkout/success', builder: (c, s) => const CheckoutSuccessScreen()),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: Center(child: Text('No route for ${state.uri}')),
    ),
    redirect: (context, state) {
      // Basic auth gate
      final goingAuth = state.matchedLocation.startsWith('/auth/');
      if (!isLoggedIn && !goingAuth) {
        return '/auth/signin';
      }
      return null;
    },
  );
}
