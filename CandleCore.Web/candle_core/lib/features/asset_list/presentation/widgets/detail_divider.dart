import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class DetailDivider extends StatelessWidget {
  final bool isDark;

  const DetailDivider({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
      indent: AppSpacing.md,
      endIndent: AppSpacing.md,
    );
  }
}
