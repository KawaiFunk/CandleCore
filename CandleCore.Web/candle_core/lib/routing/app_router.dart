import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    ],
  );
});
