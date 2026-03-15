import 'package:candle_core/shared/widgets/SkipButton/SkipButton.dart';
import 'package:candle_core/shared/widgets/onboarding/OnboardingIllustration/onboarding_illustration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/preferences_provider.dart';
import '../../../core/theme/tokens.dart';
import '../../../routing/routes.dart';
import '../../../shared/widgets/onboarding/OnBoardingTextSection/onboarding_text_section.dart';
import '../../../shared/widgets/onboarding/OnboardingNavigation/onboarding_navigation.dart';

class OnboardingScreen1 extends ConsumerWidget {
  const OnboardingScreen1({super.key});

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
                  icon: Icons.auto_graph_rounded,
                  backgroundColor: AppColors.primaryLight.withAlpha(50),
                  iconColor: AppColors.primary,
                ),
                const SizedBox(height: 50),
                OnboardingTextSection(
                  title: "Track Cryptocurrencies",
                  description:
                      "Monitor real-time prices, market caps,"
                      " and detailed analytics for all major cryptocurrencies in one place.",
                ),
              ],
            ),
            OnboardingNav(
              currentPage: 0,
              totalPages: 3,
              onNext: () => context.go(AppRoutes.onboarding2),
            ),
          ],
        ),
      ),
    );
  }
}
