import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class StatCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const StatCard({super.key, required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(children: children),
    );
  }
}
