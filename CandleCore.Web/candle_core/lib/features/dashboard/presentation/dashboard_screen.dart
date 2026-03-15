import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/tokens.dart';
import '../../../routing/routes.dart';
import '../../../shared/widgets/common/section_header.dart';
import '../../asset_list/data/asset_model.dart';
import '../../asset_list/providers/asset_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/market_summary_card.dart';
import '../widgets/mover_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final assetsAsync = ref.watch(refreshableAssetListProvider(1));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good ${_greeting()},',
              style: const TextStyle(
                fontSize: AppTypography.textSm,
                color: AppColors.textSecondary,
                fontWeight: AppTypography.fontWeightNormal,
              ),
            ),
            Text(
              user?.username ?? 'Trader',
              style: const TextStyle(
                fontSize: AppTypography.textLg,
                fontWeight: AppTypography.fontWeightBold,
              ),
            ),
          ],
        ),
        toolbarHeight: 64,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.md),
            child: CircleAvatar(
              backgroundColor: AppColors.primary.withAlpha(30),
              radius: 20,
              child: Text(
                (user?.username ?? 'U').substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: AppTypography.fontWeightBold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(assetRefreshProvider.notifier).refresh();
          await ref.read(refreshableAssetListProvider(1).future);
        },
        color: AppColors.primary,
        child: assetsAsync.when(
          data: (paged) => _DashboardContent(assets: paged.data),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
          error: (err, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: AppColors.error),
                const SizedBox(height: AppSpacing.md),
                Text('Failed to load market data',
                    style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () =>
                      ref.read(assetRefreshProvider.notifier).refresh(),
                  child: const Text('Retry',
                      style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }
}

class _DashboardContent extends StatelessWidget {
  final List<AssetModel> assets;

  const _DashboardContent({required this.assets});

  @override
  Widget build(BuildContext context) {
    final gainers = [...assets]
      ..sort((a, b) => b.percentChange1h.compareTo(a.percentChange1h));
    final losers = [...assets]
      ..sort((a, b) => a.percentChange1h.compareTo(b.percentChange1h));

    final topGainers = gainers.take(3).toList();
    final topLosers = losers.take(3).toList();

    final totalAssets = assets.length;
    final gainCount = assets.where((a) => a.percentChange1h > 0).length;
    final lossCount = assets.where((a) => a.percentChange1h < 0).length;
    final avgChange = assets.isEmpty
        ? 0.0
        : assets.map((a) => a.percentChange1h).reduce((a, b) => a + b) /
            assets.length;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        MarketSummaryCard(
          totalAssets: totalAssets,
          gainCount: gainCount,
          lossCount: lossCount,
          avgChange: avgChange,
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(
          title: 'Top Gainers',
          actionLabel: 'See all',
          onAction: () => context.go(AppRoutes.markets),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...topGainers.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: MoverCard(asset: a),
            )),
        const SizedBox(height: AppSpacing.md),
        SectionHeader(
          title: 'Top Losers',
          actionLabel: 'See all',
          onAction: () => context.go(AppRoutes.markets),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...topLosers.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: MoverCard(asset: a),
            )),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: 'Price Alerts'),
        const SizedBox(height: AppSpacing.sm),
        _PlaceholderCard(
          icon: Icons.notifications_none,
          message: 'No active alerts. Set up alerts to get notified.',
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final IconData icon;
  final String message;

  const _PlaceholderCard({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 24),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: AppTypography.textSm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
