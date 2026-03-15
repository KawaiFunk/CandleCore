import 'dart:async';

import 'package:flutter/material.dart';
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
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
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
    final activeFilters = filter.activeFilterCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markets'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.tune_rounded),
                  tooltip: 'Filter & Sort',
                  onPressed: () => showFilterBottomSheet(context),
                ),
                if (activeFilters > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$activeFilters',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: AppTypography.fontWeightBold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: TextStyle(
                fontSize: AppTypography.textBase,
                color: isDark ? AppColors.textLight : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search coins...',
                hintStyle:
                    const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close,
                            color: AppColors.textSecondary, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(assetListFilterProvider.notifier)
                              .setSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark
                    ? AppColors.inputBackgroundDark
                    : AppColors.inputBackgroundLight,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  borderSide: const BorderSide(
                      color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ),
      body: assetsAsync.when(
        data: (paged) {
          if (paged.data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off,
                      size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    filter.search.isEmpty
                        ? 'No assets match your filters'
                        : 'No results for "${filter.search}"',
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

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              ref.read(assetRefreshProvider.notifier).refresh();
              await ref.read(pagedAssetListProvider(filter).future);
            },
            child: Column(
              children: [
                if (filter.activeFilterCount > 0)
                  _ActiveFilterBar(filter: filter),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: paged.data.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) =>
                        AssetListItem(asset: paged.data[index]),
                  ),
                ),
                if (paged.totalPages > 1)
                  PaginationBar(
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
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                err is ApiException ? err.message : 'Failed to load markets.',
                style: const TextStyle(color: AppColors.textSecondary),
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

    if (filter.sortBy != AssetSortField.rank || filter.sortDirection != AssetSortDirection.asc) {
      final dir = filter.sortDirection == AssetSortDirection.desc ? '↓' : '↑';
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
        AssetChangeFilter.gainers => 'Gainers only',
        AssetChangeFilter.losers => 'Losers only',
        AssetChangeFilter.all => '',
      });
    }

    if (filter.priceMin != null || filter.priceMax != null) {
      final min = filter.priceMin != null ? '\$${filter.priceMin!.toStringAsFixed(0)}' : '\$0';
      final max = filter.priceMax != null ? '\$${filter.priceMax!.toStringAsFixed(0)}' : 'any';
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
              size: 16, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: chips
                    .map((c) => Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: _FilterChip(label: c),
                        ))
                    .toList(),
              ),
            ),
          ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
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
