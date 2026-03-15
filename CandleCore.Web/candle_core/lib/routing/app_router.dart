import 'package:candle_core/features/auth/presentation/auth_screen.dart';
import 'package:candle_core/features/auth/providers/auth_provider.dart';
import 'package:candle_core/features/dashboard/presentation/dashboard_screen.dart';
import 'package:candle_core/features/favorites/presentation/favorites_screen.dart';
import 'package:candle_core/features/notes/presentation/notes_screen.dart';
import 'package:candle_core/features/settings/presentation/settings_screen.dart';
import 'package:candle_core/features/main_shell/presentation/pages/main_shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/preferences_provider.dart';
import '../features/asset_list/presentation/asset_list_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/splash/presentation/onboarding_screen_1.dart';
import '../features/splash/presentation/onboarding_screen_2.dart';
import '../features/splash/presentation/onboarding_screen_3.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = ref.read(currentUserProvider) != null;
      final prefs = ref.read(preferencesServiceProvider);
      final onboardingDone = prefs.onboardingDone;

      final path = state.uri.path;

      final protectedRoutes = [
        AppRoutes.dashboard,
        AppRoutes.markets,
        AppRoutes.favorites,
        AppRoutes.notes,
        AppRoutes.settings,
      ];
      final isProtected = protectedRoutes.any(
        (r) => path == r || path.startsWith('$r/'),
      );

      if (isProtected && !isLoggedIn) return AppRoutes.login;

      if (path == AppRoutes.splash && onboardingDone) {
        return isLoggedIn ? AppRoutes.dashboard : AppRoutes.login;
      }

      final onboardingRoutes = [
        AppRoutes.onboarding1,
        AppRoutes.onboarding2,
        AppRoutes.onboarding3,
      ];
      if (onboardingRoutes.contains(path) && onboardingDone) {
        return isLoggedIn ? AppRoutes.dashboard : AppRoutes.login;
      }

      return null;
    },
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
        builder: (context, state) => const AuthScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.markets,
            builder: (context, state) => const AssetListScreen(),
          ),
          GoRoute(
            path: AppRoutes.favorites,
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: AppRoutes.notes,
            builder: (context, state) => const NotesScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});
