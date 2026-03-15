import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../data/asset_model.dart';
import 'detail_divider.dart';
import 'stat_card.dart';
import 'stat_row.dart';

class StatsGrid extends StatelessWidget {
  final DetailedAssetModel asset;
  final bool isDark;

  const StatsGrid({super.key, required this.asset, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Market Stats',
          style: TextStyle(
            fontSize: AppTypography.textBase,
            fontWeight: AppTypography.fontWeightSemiBold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        StatCard(
          isDark: isDark,
          children: [
            StatRow(
              label: 'Market Cap',
              value: _formatLarge(asset.marketCapUsd),
              icon: Icons.pie_chart_outline_rounded,
            ),
            DetailDivider(isDark: isDark),
            StatRow(
              label: '24h Volume',
              value: _formatLarge(asset.volume24a),
              icon: Icons.bar_chart_rounded,
            ),
          ],
        ),
      ],
    );
  }

  String _formatLarge(double value) {
    if (value >= 1e12) return '\$${(value / 1e12).toStringAsFixed(2)}T';
    if (value >= 1e9) return '\$${(value / 1e9).toStringAsFixed(2)}B';
    if (value >= 1e6) return '\$${(value / 1e6).toStringAsFixed(2)}M';
    if (value >= 1e3) return '\$${(value / 1e3).toStringAsFixed(2)}K';
    return '\$${value.toStringAsFixed(2)}';
  }
}
