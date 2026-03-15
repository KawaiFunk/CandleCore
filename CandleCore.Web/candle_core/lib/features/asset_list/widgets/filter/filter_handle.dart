import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class FilterHandle extends StatelessWidget {
  final Color borderColor;

  const FilterHandle({super.key, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: borderColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
