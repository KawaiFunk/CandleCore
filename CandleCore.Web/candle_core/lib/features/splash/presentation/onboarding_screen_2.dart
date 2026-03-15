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

class OnboardingScreen2 extends ConsumerWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> skipOnboarding() async {
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
                SkipButton(onPressed: skipOnboarding),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OnboardingIllustration(
                  icon: Icons.notifications_none_rounded,
                  backgroundColor: AppColors.primaryLight.withAlpha(50),
                  iconColor: AppColors.primary,
                ),
                const SizedBox(height: 50),
                OnboardingTextSection(
                  title: "Analyze & Create Smart Triggers",
                  description:
                      "Set up intelligent price alerts and market"
                      " triggers to never miss important trading opportunities.",
                ),
              ],
            ),
            OnboardingNav(
              currentPage: 1,
              totalPages: 3,
              onNext: () => context.go(AppRoutes.onboarding3),
              onPrevious: () => context.go(AppRoutes.onboarding1),
            ),
          ],
        ),
      ),
    );
  }
}
