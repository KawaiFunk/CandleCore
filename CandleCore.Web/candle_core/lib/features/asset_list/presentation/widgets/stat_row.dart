import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.textSm,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: AppTypography.fontWeightSemiBold,
              fontSize: AppTypography.textSm,
            ),
          ),
        ],
      ),
    );
  }
}
