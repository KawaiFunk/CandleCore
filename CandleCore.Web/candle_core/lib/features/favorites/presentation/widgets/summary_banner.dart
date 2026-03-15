import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import 'banner_stat.dart';

class SummaryBanner extends StatelessWidget {
  final double avgChange;
  final int gainers;
  final int losers;
  final int total;

  const SummaryBanner({
    super.key,
    required this.avgChange,
    required this.gainers,
    required this.losers,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = avgChange >= 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.primary.withAlpha(20)
            : AppColors.error.withAlpha(20),
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: isPositive
              ? AppColors.primary.withAlpha(60)
              : AppColors.error.withAlpha(60),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BannerStat(
            label: 'Avg Change',
            value: '${isPositive ? '+' : ''}${avgChange.toStringAsFixed(2)}%',
            color: isPositive ? AppColors.primary : AppColors.error,
          ),
          BannerStat(
            label: 'Gainers',
            value: '$gainers',
            color: AppColors.primary,
          ),
          BannerStat(
            label: 'Losers',
            value: '$losers',
            color: AppColors.error,
          ),
          BannerStat(
            label: 'Total',
            value: '$total',
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
