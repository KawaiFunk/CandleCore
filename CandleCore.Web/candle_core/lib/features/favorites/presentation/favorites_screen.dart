import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../shared/widgets/common/empty_state.dart';
import '../../asset_list/providers/asset_provider.dart';
import '../../dashboard/widgets/mover_card.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final assetsAsync = ref.watch(refreshableAssetListProvider(1));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          if (favorites.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(30),
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                  ),
                  child: Text(
                    '${favorites.length} assets',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: AppTypography.textXs,
                      fontWeight: AppTypography.fontWeightSemiBold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: favorites.isEmpty
          ? const EmptyState(
              icon: Icons.star_border_rounded,
              title: 'No favorites yet',
              subtitle:
                  'Go to Markets and tap the star icon to add assets to your watchlist.',
            )
          : assetsAsync.when(
              data: (paged) {
                final favoriteAssets = paged.data
                    .where((a) => favorites.contains(a.symbol))
                    .toList();

                if (favoriteAssets.isEmpty) {
                  return const EmptyState(
                    icon: Icons.sync,
                    title: 'Assets not loaded yet',
                    subtitle: 'Your favorites will appear here once synced.',
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () async {
                    ref.read(assetRefreshProvider.notifier).refresh();
                    await ref.read(refreshableAssetListProvider(1).future);
                  },
                  child: _FavoriteSummary(
                    assets: favoriteAssets,
                    ref: ref,
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
              error: (_, __) => const EmptyState(
                icon: Icons.error_outline,
                title: 'Failed to load',
                subtitle: 'Pull down to refresh.',
              ),
            ),
    );
  }
}

class _FavoriteSummary extends StatelessWidget {
  final List assets;
  final WidgetRef ref;

  const _FavoriteSummary({required this.assets, required this.ref});

  @override
  Widget build(BuildContext context) {
    final gainers = assets.where((a) => a.percentChange1h > 0).length;
    final losers = assets.where((a) => a.percentChange1h < 0).length;
    final avgChange = assets.isEmpty
        ? 0.0
        : assets
                .map((a) => a.percentChange1h as double)
                .reduce((a, b) => a + b) /
            assets.length;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _SummaryBanner(
          avgChange: avgChange,
          gainers: gainers,
          losers: losers,
          total: assets.length,
        ),
        const SizedBox(height: AppSpacing.lg),
        ...assets.map((asset) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: MoverCard(asset: asset),
            )),
      ],
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  final double avgChange;
  final int gainers;
  final int losers;
  final int total;

  const _SummaryBanner({
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
          _BannerStat(
              label: 'Avg Change',
              value:
                  '${isPositive ? '+' : ''}${avgChange.toStringAsFixed(2)}%',
              color: isPositive ? AppColors.primary : AppColors.error),
          _BannerStat(
              label: 'Gainers', value: '$gainers', color: AppColors.primary),
          _BannerStat(
              label: 'Losers', value: '$losers', color: AppColors.error),
          _BannerStat(
              label: 'Total',
              value: '$total',
              color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _BannerStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BannerStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: AppTypography.textLg,
            fontWeight: AppTypography.fontWeightBold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppTypography.textXs,
          ),
        ),
      ],
    );
  }
}
