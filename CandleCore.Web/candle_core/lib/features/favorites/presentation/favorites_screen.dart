import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../shared/widgets/asset/asset_list_item/asset_list_item.dart';
import '../../../shared/widgets/common/empty_state.dart';
import '../providers/favorites_provider.dart';
import 'widgets/summary_banner.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          favoritesAsync.when(
            data: (favorites) => favorites.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amber.withAlpha(30),
                          borderRadius: BorderRadius.circular(AppRadii.lg),
                        ),
                        child: Text(
                          '${favorites.length} assets',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: AppTypography.textXs,
                            fontWeight: AppTypography.fontWeightSemiBold,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return const EmptyState(
              icon: Icons.star_border_rounded,
              title: 'No favorites yet',
              subtitle:
                  'Go to Markets and tap the star icon to add assets to your watchlist.',
            );
          }

          final gainers = favorites.where((a) => a.percentChange1h > 0).length;
          final losers = favorites.where((a) => a.percentChange1h < 0).length;
          final avgChange = favorites
                  .map((a) => a.percentChange1h)
                  .reduce((a, b) => a + b) /
              favorites.length;

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => ref.invalidate(favoritesProvider),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                SummaryBanner(
                  avgChange: avgChange,
                  gainers: gainers,
                  losers: losers,
                  total: favorites.length,
                ),
                const SizedBox(height: AppSpacing.lg),
                ...favorites.map(
                  (asset) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: AssetListItem(asset: asset),
                  ),
                ),
              ],
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
