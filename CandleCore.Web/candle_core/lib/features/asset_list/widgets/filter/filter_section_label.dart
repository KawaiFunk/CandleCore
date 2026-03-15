import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class FilterSectionLabel extends StatelessWidget {
  final String text;

  const FilterSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: AppTypography.textSm,
        fontWeight: AppTypography.fontWeightSemiBold,
        color: AppColors.textSecondary,
        letterSpacing: AppTypography.letterSpacingWide,
      ),
    );
  }
}
