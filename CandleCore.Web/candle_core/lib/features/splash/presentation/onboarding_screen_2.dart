import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../routing/routes.dart';
import '../../../shared/widgets/SkipButton/SkipButton.dart';
import '../../../shared/widgets/onboarding/OnBoardingTextSection/onboarding_text_section.dart';
import '../../../shared/widgets/onboarding/OnboardingIllustration/onboarding_illustration.dart';
import '../../../shared/widgets/onboarding/OnboardingNavigation/onboarding_navigation.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  int currentPage = 1;
  final int totalPages = 3;

  void onNext() {
    context.go(AppRoutes.onboarding3);
  }

  void onPrevious() {
    context.go(AppRoutes.onboarding1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SkipButton(onPressed: () => context.go(AppRoutes.login)),
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
              currentPage: currentPage,
              totalPages: totalPages,
              onNext: onNext,
              onPrevious: onPrevious,
            ),
          ],
        ),
      ),
    );
  }
}
