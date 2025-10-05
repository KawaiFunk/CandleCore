import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class OnboardingNav extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;

  const OnboardingNav({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalPages, (index) {
            final isActive = index == currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary
                    : AppColors.textSecondary.withAlpha(80),
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (onPrevious != null)
              TextButton(
                onPressed: onPrevious,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: Colors.transparent,
                  textStyle: const TextStyle(
                    fontSize: AppTypography.textBase,
                    fontWeight: AppTypography.fontWeightMedium,
                  ),
                ),
                child: const Text('Previous'),
              )
            else
              SizedBox(height: 0, width: 0),

            ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isFinalPage() ? 'Get Started' : 'Next',
                    style: TextStyle(
                      fontWeight: AppTypography.fontWeightMedium,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isFinalPage()
                        ? Icons.arrow_forward_rounded
                        : Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  isFinalPage() {
    return currentPage == totalPages - 1;
  }
}
