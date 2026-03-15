import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class RankBadge extends StatelessWidget {
  final int rank;

  const RankBadge({super.key, required this.rank});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Text(
        '#$rank',
        style: const TextStyle(
          fontSize: AppTypography.textXs,
          fontWeight: AppTypography.fontWeightSemiBold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
