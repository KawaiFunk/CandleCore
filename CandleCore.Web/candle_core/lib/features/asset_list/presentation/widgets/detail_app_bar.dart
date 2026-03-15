import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../shared/widgets/asset/asset_illustration/asset_illustration.dart';
import '../../data/asset_model.dart';
import 'rank_badge.dart';

class DetailAppBar extends StatelessWidget {
  final DetailedAssetModel asset;
  final bool isFavorite;
  final Color changeColor;
  final bool isPositive;
  final bool isDark;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddNoteTap;

  const DetailAppBar({
    super.key,
    required this.asset,
    required this.isFavorite,
    required this.changeColor,
    required this.isPositive,
    required this.isDark,
    required this.onFavoriteTap,
    required this.onAddNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 200,
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.sticky_note_2_outlined, size: 22),
          color: AppColors.textSecondary,
          onPressed: onAddNoteTap,
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
            color: isFavorite ? Colors.amber : AppColors.textSecondary,
          ),
          onPressed: onFavoriteTap,
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          color: bg,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.xxl + AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AssetIllustration(
                text: asset.symbol,
                backgroundColor: AppColors.primary.withAlpha(25),
                iconColor: AppColors.primary,
                size: 56,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.name,
                      style: const TextStyle(
                        fontSize: AppTypography.text2xl,
                        fontWeight: AppTypography.fontWeightBold,
                        letterSpacing: AppTypography.letterSpacingTight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          asset.symbol,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppTypography.textSm,
                            fontWeight: AppTypography.fontWeightMedium,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        RankBadge(rank: asset.rank),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
