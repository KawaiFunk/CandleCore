import 'package:flutter/material.dart';
import '../../../core/theme/tokens.dart';
import '../../asset_list/data/asset_model.dart';
import '../../../shared/widgets/asset/asset_illustration/asset_illustration.dart';

class MoverCard extends StatelessWidget {
  final AssetModel asset;

  const MoverCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPositive = asset.percentChange1h >= 0;
    final changeColor = isPositive ? AppColors.primary : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          AssetIllustration(
            text: asset.symbol,
            backgroundColor: AppColors.primary.withAlpha(25),
            iconColor: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  asset.name,
                  style: const TextStyle(
                    fontWeight: AppTypography.fontWeightSemiBold,
                    fontSize: AppTypography.textBase,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  asset.symbol,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: AppTypography.textXs,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${_formatPrice(asset.priceUsd)}',
                style: const TextStyle(
                  fontWeight: AppTypography.fontWeightSemiBold,
                  fontSize: AppTypography.textBase,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: changeColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 14,
                      color: changeColor,
                    ),
                    Text(
                      '${asset.percentChange1h.abs().toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: changeColor,
                        fontSize: AppTypography.textXs,
                        fontWeight: AppTypography.fontWeightSemiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    if (price >= 1) return price.toStringAsFixed(2);
    return price.toStringAsFixed(6);
  }
}
