import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../features/favorites/providers/favorites_provider.dart';
import '../../../shared/widgets/asset/asset_illustration/asset_illustration.dart';
import '../data/asset_model.dart';
import '../providers/asset_provider.dart';

class AssetDetailScreen extends ConsumerWidget {
  final int assetId;

  const AssetDetailScreen({super.key, required this.assetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAsset = ref.watch(assetDetailProvider(assetId));

    return asyncAsset.when(
      data: (asset) => _DetailView(asset: asset),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: AppSpacing.md),
                Text(
                  err is ApiException ? err.message : 'Failed to load asset.',
                  style: const TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => ref.invalidate(assetDetailProvider(assetId)),
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
}

class _DetailView extends ConsumerWidget {
  final DetailedAssetModel asset;

  const _DetailView({required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFavorite = ref.watch(
      favoritesProvider.select((s) => s.contains(asset.symbol)),
    );
    final isPositive = asset.percentChange1h >= 0;
    final changeColor = isPositive ? AppColors.primary : AppColors.error;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _DetailAppBar(
            asset: asset,
            isFavorite: isFavorite,
            changeColor: changeColor,
            isPositive: isPositive,
            isDark: isDark,
            onFavoriteTap: () =>
                ref.read(favoritesProvider.notifier).toggle(asset.symbol),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PriceHeader(asset: asset, changeColor: changeColor, isPositive: isPositive),
                  const SizedBox(height: AppSpacing.lg),
                  _StatsGrid(asset: asset, isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),
                  _ChangeSection(asset: asset, isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailAppBar extends StatelessWidget {
  final DetailedAssetModel asset;
  final bool isFavorite;
  final Color changeColor;
  final bool isPositive;
  final bool isDark;
  final VoidCallback onFavoriteTap;

  const _DetailAppBar({
    required this.asset,
    required this.isFavorite,
    required this.changeColor,
    required this.isPositive,
    required this.isDark,
    required this.onFavoriteTap,
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
          icon: Icon(
            isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
            color: isFavorite ? AppColors.primary : AppColors.textSecondary,
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
                        _RankBadge(rank: asset.rank),
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

class _RankBadge extends StatelessWidget {
  final int rank;
  const _RankBadge({required this.rank});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Text(
        '#$rank',
        style: const TextStyle(
          fontSize: AppTypography.textXs,
          fontWeight: AppTypography.fontWeightSemiBold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _PriceHeader extends StatelessWidget {
  final DetailedAssetModel asset;
  final Color changeColor;
  final bool isPositive;

  const _PriceHeader({
    required this.asset,
    required this.changeColor,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Price',
                style: TextStyle(
                  fontSize: AppTypography.textSm,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${_formatPrice(asset.priceUsd)}',
                style: const TextStyle(
                  fontSize: AppTypography.text3xl,
                  fontWeight: AppTypography.fontWeightBold,
                  letterSpacing: AppTypography.letterSpacingTight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₿ ${_formatBtc(asset.priceBtc)}',
                style: const TextStyle(
                  fontSize: AppTypography.textSm,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: changeColor.withAlpha(20),
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: changeColor.withAlpha(60)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 16,
                color: changeColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${asset.percentChange1h.abs().toStringAsFixed(2)}%',
                style: TextStyle(
                  color: changeColor,
                  fontWeight: AppTypography.fontWeightBold,
                  fontSize: AppTypography.textBase,
                ),
              ),
            ],
          ),
        ),
      ],
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

  String _formatBtc(double btc) {
    if (btc == 0) return '0';
    if (btc < 0.00001) return btc.toStringAsExponential(2);
    return btc.toStringAsFixed(8);
  }
}

class _StatsGrid extends StatelessWidget {
  final DetailedAssetModel asset;
  final bool isDark;

  const _StatsGrid({required this.asset, required this.isDark});

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
        _StatCard(
          isDark: isDark,
          children: [
            _StatRow(
              label: 'Market Cap',
              value: _formatLarge(asset.marketCapUsd),
              icon: Icons.pie_chart_outline_rounded,
            ),
            _Divider(isDark: isDark),
            _StatRow(
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

class _ChangeSection extends StatelessWidget {
  final DetailedAssetModel asset;
  final bool isDark;

  const _ChangeSection({required this.asset, required this.isDark});

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
        _StatCard(
          isDark: isDark,
          children: [
            _ChangeRow(label: '1 Hour', value: asset.percentChange1h),
            _Divider(isDark: isDark),
            _ChangeRow(label: '24 Hours', value: asset.percentChange24h),
            _Divider(isDark: isDark),
            _ChangeRow(label: '7 Days', value: asset.percentChange7d),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _StatCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.textSm,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: AppTypography.fontWeightSemiBold,
              fontSize: AppTypography.textSm,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeRow extends StatelessWidget {
  final String label;
  final double value;

  const _ChangeRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isPositive = value >= 0;
    final color = isPositive ? AppColors.primary : AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.textSm,
            ),
          ),
          const Spacer(),
          Icon(
            isPositive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '${value.abs().toStringAsFixed(2)}%',
            style: TextStyle(
              color: color,
              fontWeight: AppTypography.fontWeightSemiBold,
              fontSize: AppTypography.textSm,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
      indent: AppSpacing.md,
      endIndent: AppSpacing.md,
    );
  }
}
