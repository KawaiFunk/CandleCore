import 'package:candle_core/shared/widgets/asset/asset_stats_card/stat_item.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../features/asset_list/data/asset_model.dart';

class AssetStats {
  final int gainers;
  final int losers;
  final int total;

  const AssetStats({
    required this.gainers,
    required this.losers,
    required this.total,
  });

  factory AssetStats.fromAssets(List<AssetModel> assets) {
    int gainers = 0;
    int losers = 0;

    for (final asset in assets) {
      if (asset.percentChange1h > 0) {
        gainers++;
      } else if (asset.percentChange1h < 0) {
        losers++;
      }
    }

    return AssetStats(gainers: gainers, losers: losers, total: assets.length);
  }
}

class AssetStatsCard extends StatelessWidget {
  final AssetStats stats;
  final String period;

  const AssetStatsCard({super.key, required this.stats, this.period = '1h'});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Text(
                'Market Overview',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatItem(
                  icon: Icons.trending_up,
                  iconColor: AppColors.success,
                  backgroundColor: AppColors.success.withAlpha(30),
                  label: 'Gainers',
                  value: stats.gainers.toString(),
                  textColor: AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatItem(
                  icon: Icons.trending_down,
                  iconColor: AppColors.error,
                  backgroundColor: AppColors.error.withAlpha(30),
                  label: 'Losers',
                  value: stats.losers.toString(),
                  textColor: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
