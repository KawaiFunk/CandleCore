// dart
import 'package:candle_core/features/asset_list/presentation/asset_list_screen.dart';
import 'package:candle_core/features/main_shell/presentation/pages/main_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../features/splash/presentation/splash_screen.dart';
import '../features/splash/presentation/onboarding_screen_1.dart';
import '../features/splash/presentation/onboarding_screen_2.dart';
import '../features/splash/presentation/onboarding_screen_3.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding1,
        builder: (context, state) => const OnboardingScreen1(),
      ),
      GoRoute(
        path: AppRoutes.onboarding2,
        builder: (context, state) => const OnboardingScreen2(),
      ),
      GoRoute(
        path: AppRoutes.onboarding3,
        builder: (context, state) => const OnboardingScreen3(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Login Screen')),
        ),
      ),

      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => Scaffold(
              appBar: AppBar(
                title: const Text('Dashboard'),
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              body: const SafeArea(
                child: Center(child: Text('Dashboard Screen')),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.markets,
            builder: (context, state) => const AssetListScreen(),
          ),
          GoRoute(
            path: AppRoutes.favorites,
            builder: (context, state) => Scaffold(
              appBar: AppBar(
                title: const Text('Favorites'),
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              body: const SafeArea(
                child: Center(child: Text('Favorites Screen')),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              body: const SafeArea(
                child: Center(child: Text('Profile Screen')),
              ),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => Scaffold(
              appBar: AppBar(
                title: const Text('Settings'),
                systemOverlayStyle: SystemUiOverlayStyle.dark,
              ),
              body: const SafeArea(
                child: Center(child: Text('Settings Screen')),
              ),
            ),
          ),
        ],
      ),
    ],
  );
});
