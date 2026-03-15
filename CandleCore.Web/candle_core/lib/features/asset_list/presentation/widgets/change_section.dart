import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../data/detailed_asset_model.dart';
import 'change_row.dart';
import 'detail_divider.dart';
import 'stat_card.dart';

class ChangeSection extends StatelessWidget {
  final DetailedAssetModel asset;
  final bool isDark;

  const ChangeSection({super.key, required this.asset, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Change',
          style: TextStyle(
            fontSize: AppTypography.textBase,
            fontWeight: AppTypography.fontWeightSemiBold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        StatCard(
          isDark: isDark,
          children: [
            ChangeRow(label: '1 Hour', value: asset.percentChange1h),
            DetailDivider(isDark: isDark),
            ChangeRow(label: '24 Hours', value: asset.percentChange24h),
            DetailDivider(isDark: isDark),
            ChangeRow(label: '7 Days', value: asset.percentChange7d),
          ],
        ),
      ],
    );
  }
}
