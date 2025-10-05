import 'package:candle_core/shared/widgets/SkipButton/SkipButton.dart';
import 'package:candle_core/shared/widgets/onboarding/OnboardingIllustration/onboarding_illustration.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../routing/routes.dart';
import '../../../shared/widgets/onboarding/OnBoardingTextSection/onboarding_text_section.dart';
import '../../../shared/widgets/onboarding/OnboardingNavigation/onboarding_navigation.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  int currentPage = 0;
  final int totalPages = 3;

  void onNext() {
    context.go(AppRoutes.onboarding2);
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
              currentPage: currentPage,
              totalPages: totalPages,
              onNext: onNext,
            ),
          ],
        ),
      ),
    );
  }
}
