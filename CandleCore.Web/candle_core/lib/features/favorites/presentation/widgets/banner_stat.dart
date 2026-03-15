import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class BannerStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const BannerStat({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: AppTypography.textLg,
            fontWeight: AppTypography.fontWeightBold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppTypography.textXs,
          ),
        ),
      ],
    );
  }
}
