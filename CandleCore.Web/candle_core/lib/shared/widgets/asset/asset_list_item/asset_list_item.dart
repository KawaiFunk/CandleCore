import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../features/asset_list/data/asset_model.dart';
import '../../../../features/favorites/providers/favorites_provider.dart';
import '../../../../routing/routes.dart';
import '../asset_illustration/asset_illustration.dart';

class AssetListItem extends ConsumerWidget {
  final AssetModel asset;

  const AssetListItem({super.key, required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFavorite = ref.watch(
      favoritesProvider.select((s) => s.containsId(asset.id)),
    );
    final isPositive = asset.percentChange1h >= 0;
    final changeColor = isPositive ? AppColors.primary : AppColors.error;

    return GestureDetector(
      onTap: () => context.push(AppRoutes.assetDetailPath(asset.id)),
      child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AppRadii.xl),
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
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
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: () =>
                ref.read(favoritesProvider.notifier).toggle(asset.id),
            child: Icon(
              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: isFavorite ? Colors.amber : AppColors.textSecondary,
              size: 22,
            ),
          ),
        ],
      ),
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
