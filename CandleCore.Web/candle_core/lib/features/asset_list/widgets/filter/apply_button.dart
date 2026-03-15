import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class ApplyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ApplyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
        ),
        child: const Text(
          'Apply Filters',
          style: TextStyle(
            color: Colors.white,
            fontWeight: AppTypography.fontWeightSemiBold,
            fontSize: AppTypography.textBase,
          ),
        ),
      ),
    );
  }
}
