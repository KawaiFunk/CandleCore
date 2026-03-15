import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../shared/widgets/asset/asset_list_item/asset_list_item.dart';
import '../../../shared/widgets/common/pagination_bar.dart';
import '../providers/asset_provider.dart';
import '../widgets/filter_bottom_sheet.dart';

class AssetListScreen extends ConsumerStatefulWidget {
  const AssetListScreen({super.key});

  @override
  ConsumerState<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends ConsumerState<AssetListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(assetListFilterProvider.notifier).setSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(assetListFilterProvider);
    final assetsAsync = ref.watch(pagedAssetListProvider(filter));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: assetsAsync.when(
        data: (paged) => RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.read(assetRefreshProvider.notifier).refresh();
            await ref.read(pagedAssetListProvider(filter).future);
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _MarketsHeader(
                searchController: _searchController,
                onSearchChanged: _onSearchChanged,
                filter: filter,
                isDark: isDark,
              ),
              if (filter.activeFilterCount > 0)
                SliverToBoxAdapter(
                  child: _ActiveFilterBar(filter: filter),
                ),
              if (paged.data.isEmpty)
                SliverFillRemaining(
                  child: _EmptyState(filter: filter),
                )
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  sliver: SliverList.separated(
                    itemCount: paged.data.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) =>
                        AssetListItem(asset: paged.data[index]),
                  ),
                ),
                if (paged.totalPages > 1)
                  SliverToBoxAdapter(
                    child: PaginationBar(
                      currentPage: paged.pageNumber,
                      totalPages: paged.totalPages,
                      hasPrevious: paged.hasPreviousPage,
                      hasNext: paged.hasNextPage,
                      onPrevious: () => ref
                          .read(assetListFilterProvider.notifier)
                          .setPage(filter.page - 1),
                      onNext: () => ref
                          .read(assetListFilterProvider.notifier)
                          .setPage(filter.page + 1),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
              ],
            ],
          ),
        ),
        loading: () => CustomScrollView(
          slivers: [
            _MarketsHeader(
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              filter: filter,
              isDark: isDark,
            ),
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ),
        error: (err, _) => CustomScrollView(
          slivers: [
            _MarketsHeader(
              searchController: _searchController,
              onSearchChanged: _onSearchChanged,
              filter: filter,
              isDark: isDark,
            ),
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: AppColors.error),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        err is ApiException
                            ? err.message
                            : 'Failed to load markets.',
                        style:
                            const TextStyle(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
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
          ],
        ),
      ),
    );
  }
}

class _MarketsHeader extends ConsumerWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final AssetListFilter filter;
  final bool isDark;

  const _MarketsHeader({
    required this.searchController,
    required this.onSearchChanged,
    required this.filter,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilters = filter.activeFilterCount;
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _MarketsHeaderDelegate(
        topPadding: topPadding,
        expandedHeight: topPadding + 140,
        collapsedHeight: topPadding + 64,
        searchController: searchController,
        onSearchChanged: onSearchChanged,
        activeFilters: activeFilters,
        isDark: isDark,
        onFilterTap: () => showFilterBottomSheet(context),
      ),
    );
  }
}

class _MarketsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double topPadding;
  final double expandedHeight;
  final double collapsedHeight;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final int activeFilters;
  final bool isDark;
  final VoidCallback onFilterTap;

  const _MarketsHeaderDelegate({
    required this.topPadding,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.searchController,
    required this.onSearchChanged,
    required this.activeFilters,
    required this.isDark,
    required this.onFilterTap,
  });

  @override
  double get maxExtent => expandedHeight;
  @override
  double get minExtent => collapsedHeight;
  @override
  bool shouldRebuild(_MarketsHeaderDelegate old) =>
      old.activeFilters != activeFilters ||
      old.isDark != isDark ||
      old.searchController.text != searchController.text;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final titleOpacity = (1.0 - progress * 2).clamp(0.0, 1.0);
    final collapsedTitleOpacity = ((progress - 0.5) * 2).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(
            color: overlapsContent ? borderColor : Colors.transparent,
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: topPadding + AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
            child: Opacity(
              opacity: titleOpacity,
              child: const Text(
                'Markets',
                style: TextStyle(
                  fontSize: AppTypography.text2xl,
                  fontWeight: AppTypography.fontWeightBold,
                  letterSpacing: AppTypography.letterSpacingTight,
                ),
              ),
            ),
          ),
          Positioned(
            top: topPadding + 12,
            left: AppSpacing.md,
            child: Opacity(
              opacity: collapsedTitleOpacity,
              child: const Text(
                'Markets',
                style: TextStyle(
                  fontSize: AppTypography.textLg,
                  fontWeight: AppTypography.fontWeightBold,
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Row(
              children: [
                Expanded(
                  child: _SearchField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterButton(
                  activeFilters: activeFilters,
                  isDark: isDark,
                  onTap: onFilterTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isDark;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBackgroundDark : AppColors.inputBackgroundLight,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: AppTypography.textSm,
          color: isDark ? AppColors.textLight : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search coins...',
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppTypography.textSm,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary,
            size: 18,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                    onChanged('');
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 16,
                  ),
                )
              : null,
          filled: false,
          isCollapsed: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final int activeFilters;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterButton({
    required this.activeFilters,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasActive = activeFilters > 0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: hasActive
              ? AppColors.primary
              : isDark
                  ? AppColors.inputBackgroundDark
                  : AppColors.inputBackgroundLight,
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune_rounded,
              size: 16,
              color: hasActive ? Colors.white : AppColors.textSecondary,
            ),
            if (hasActive) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$activeFilters',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppTypography.textSm,
                  fontWeight: AppTypography.fontWeightBold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends ConsumerWidget {
  final AssetListFilter filter;
  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 48, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.md),
          Text(
            filter.search.isNotEmpty
                ? 'No results for "${filter.search}"'
                : 'No assets match your filters',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          if (filter.activeFilterCount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () =>
                  ref.read(assetListFilterProvider.notifier).resetFilters(),
              child: const Text(
                'Clear filters',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActiveFilterBar extends ConsumerWidget {
  final AssetListFilter filter;
  const _ActiveFilterBar({required this.filter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.secondaryDark : AppColors.secondaryLight;

    final chips = <String>[];

    if (filter.sortBy != AssetSortField.rank ||
        filter.sortDirection != AssetSortDirection.asc) {
      final dir =
          filter.sortDirection == AssetSortDirection.desc ? '↓' : '↑';
      final name = switch (filter.sortBy) {
        AssetSortField.rank => 'Rank',
        AssetSortField.price => 'Price',
        AssetSortField.change => '1h Change',
        AssetSortField.name => 'Name',
        AssetSortField.marketcap => 'Market Cap',
      };
      chips.add('$name $dir');
    }

    if (filter.changeFilter != AssetChangeFilter.all) {
      chips.add(switch (filter.changeFilter) {
        AssetChangeFilter.gainers => 'Gainers',
        AssetChangeFilter.losers => 'Losers',
        AssetChangeFilter.all => '',
      });
    }

    if (filter.priceMin != null || filter.priceMax != null) {
      final min = filter.priceMin != null
          ? '\$${filter.priceMin!.toStringAsFixed(0)}'
          : '\$0';
      final max = filter.priceMax != null
          ? '\$${filter.priceMax!.toStringAsFixed(0)}'
          : 'any';
      chips.add('$min – $max');
    }

    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_list_rounded,
              size: 14, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: chips
                    .map((c) => Padding(
                          padding:
                              const EdgeInsets.only(right: AppSpacing.xs),
                          child: _FilterChip(label: c),
                        ))
                    .toList(),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            onTap: () =>
                ref.read(assetListFilterProvider.notifier).resetFilters(),
            child: const Text(
              'Clear',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: AppTypography.textSm,
                fontWeight: AppTypography.fontWeightSemiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(isDark ? 40 : 25),
        borderRadius: BorderRadius.circular(AppRadii.sm),
        border: Border.all(color: AppColors.primary.withAlpha(80)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: AppTypography.textXs,
          fontWeight: AppTypography.fontWeightMedium,
        ),
      ),
    );
  }
}
