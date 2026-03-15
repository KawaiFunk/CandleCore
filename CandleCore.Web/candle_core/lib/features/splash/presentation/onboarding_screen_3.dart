import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/preferences_provider.dart';
import '../../../core/theme/tokens.dart';
import '../../../routing/routes.dart';
import '../../../shared/widgets/SkipButton/SkipButton.dart';
import '../../../shared/widgets/onboarding/OnBoardingTextSection/onboarding_text_section.dart';
import '../../../shared/widgets/onboarding/OnboardingIllustration/onboarding_illustration.dart';
import '../../../shared/widgets/onboarding/OnboardingNavigation/onboarding_navigation.dart';

class OnboardingScreen3 extends ConsumerWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> finishOnboarding() async {
      await ref.read(preferencesServiceProvider).setOnboardingDone();
      if (context.mounted) context.go(AppRoutes.login);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SkipButton(onPressed: finishOnboarding),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OnboardingIllustration(
                  icon: Icons.favorite_border_rounded,
                  backgroundColor: AppColors.primaryLight.withAlpha(50),
                  iconColor: AppColors.primary,
                ),
                const SizedBox(height: 50),
                OnboardingTextSection(
                  title: "Stay Organized with Favorites and Notes",
                  description:
                      "Keep track of your favorite coins and add"
                      " personal notes for better investment planning.",
                ),
              ],
            ),
            OnboardingNav(
              currentPage: 2,
              totalPages: 3,
              onNext: finishOnboarding,
              onPrevious: () => context.go(AppRoutes.onboarding2),
            ),
          ],
        ),
      ),
    );
  }
}
