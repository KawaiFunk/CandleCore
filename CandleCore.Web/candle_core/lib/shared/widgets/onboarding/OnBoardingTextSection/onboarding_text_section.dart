import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class OnboardingTextSection extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingTextSection({
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary, height: 1.5),
        ),
      ],
    );
  }
}
