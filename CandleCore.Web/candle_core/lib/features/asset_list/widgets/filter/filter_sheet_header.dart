import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class FilterSheetHeader extends StatelessWidget {
  final VoidCallback onReset;

  const FilterSheetHeader({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filter & Sort',
          style: TextStyle(
            fontSize: AppTypography.textLg,
            fontWeight: AppTypography.fontWeightBold,
          ),
        ),
        TextButton(
          onPressed: onReset,
          child: const Text(
            'Reset',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
        ),
      ],
    );
  }
}
