import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class ChangeRow extends StatelessWidget {
  final String label;
  final double value;

  const ChangeRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final color = isPositive ? AppColors.primary : AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.textSm,
            ),
          ),
          const Spacer(),
          Icon(
            isPositive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${value.abs().toStringAsFixed(2)}%',
            style: TextStyle(
              color: color,
              fontWeight: AppTypography.fontWeightSemiBold,
              fontSize: AppTypography.textSm,
            ),
          ),
        ],
      ),
    );
  }
}
