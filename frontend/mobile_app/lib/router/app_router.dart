import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../spec/json_screen.dart';
import '../widgets/shell_scaffold.dart';

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
            builder: (context, state) => const JsonScreen(routePath: '/home'),
          ),
          GoRoute(
            path: '/community',
            builder: (context, state) => const JsonScreen(routePath: '/community'),
            routes: [
              GoRoute(
                path: 'detail/:id',
                builder: (context, state) => const JsonScreen(routePath: '/community/detail/:id'),
              ),
              GoRoute(
                path: 'new',
                builder: (context, state) => const JsonScreen(routePath: '/community/new'),
              ),
            ],
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const JsonScreen(routePath: '/history'),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const JsonScreen(routePath: '/profile'),
            routes: [
              GoRoute(
                path: 'reminders',
                builder: (context, state) => const JsonScreen(routePath: '/profile/reminders'),
              ),
              GoRoute(
                path: 'goals',
                builder: (context, state) => const JsonScreen(routePath: '/profile/goals'),
              ),
              GoRoute(
                path: 'basic',
                builder: (context, state) => const JsonScreen(routePath: '/profile/basic'),
              ),
            ],
          ),
        ],
      ),

      // Auth + onboarding flows
      GoRoute(path: '/onboarding', builder: (c, s) => const JsonScreen(routePath: '/onboarding')),
      GoRoute(path: '/preferences/categories', builder: (c, s) => const JsonScreen(routePath: '/preferences/categories')),
      GoRoute(path: '/auth/signup', builder: (c, s) => const JsonScreen(routePath: '/auth/signup')),
      GoRoute(path: '/auth/signin', builder: (c, s) => const JsonScreen(routePath: '/auth/signin')),

      // Survey
      GoRoute(path: '/survey/skin-type', builder: (c, s) => const JsonScreen(routePath: '/survey/skin-type')),
      GoRoute(path: '/survey/concerns', builder: (c, s) => const JsonScreen(routePath: '/survey/concerns')),

      // Scan flow + advice + routine
      GoRoute(path: '/scan/prepare', builder: (c, s) => const JsonScreen(routePath: '/scan/prepare')),
      GoRoute(path: '/scan/capture', builder: (c, s) => const JsonScreen(routePath: '/scan/capture')),
      GoRoute(path: '/scan/result', builder: (c, s) => const JsonScreen(routePath: '/scan/result')),
      GoRoute(path: '/advice', builder: (c, s) => const JsonScreen(routePath: '/advice')),
      GoRoute(path: '/routine', builder: (c, s) => const JsonScreen(routePath: '/routine')),

      // Products
      GoRoute(path: '/products', builder: (c, s) => const JsonScreen(routePath: '/products')),
      GoRoute(path: '/products/:id', builder: (c, s) => const JsonScreen(routePath: '/products/:id')),

      // Lifestyle
      GoRoute(path: '/lifestyle', builder: (c, s) => const JsonScreen(routePath: '/lifestyle')),

      // Paywall + checkout
      GoRoute(path: '/paywall', builder: (c, s) => const JsonScreen(routePath: '/paywall')),
      GoRoute(path: '/checkout/method', builder: (c, s) => const JsonScreen(routePath: '/checkout/method')),
      GoRoute(path: '/checkout/card', builder: (c, s) => const JsonScreen(routePath: '/checkout/card')),
      GoRoute(path: '/checkout/qr', builder: (c, s) => const JsonScreen(routePath: '/checkout/qr')),
      GoRoute(path: '/checkout/success', builder: (c, s) => const JsonScreen(routePath: '/checkout/success')),
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

