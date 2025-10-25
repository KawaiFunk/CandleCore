import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../routing/routes.dart';
import '../../../shared/widgets/SkipButton/SkipButton.dart';
import '../../../shared/widgets/onboarding/OnBoardingTextSection/onboarding_text_section.dart';
import '../../../shared/widgets/onboarding/OnboardingIllustration/onboarding_illustration.dart';
import '../../../shared/widgets/onboarding/OnboardingNavigation/onboarding_navigation.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<StatefulWidget> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
  int currentPage = 2;
  final int totalPages = 3;

  void onNext() {
    context.go(AppRoutes.markets);
  }

  void onPrevious() {
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
