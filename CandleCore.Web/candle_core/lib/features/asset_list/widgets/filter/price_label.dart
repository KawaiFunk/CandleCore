import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class PriceLabel extends StatelessWidget {
  final String label;
  final String value;

  const PriceLabel({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTypography.textXs,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppTypography.textSm,
            fontWeight: AppTypography.fontWeightSemiBold,
          ),
        ),
      ],
    );
  }
}
