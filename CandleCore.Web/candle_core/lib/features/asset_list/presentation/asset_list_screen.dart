import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../shared/widgets/asset/asset_list_item/asset_list_item.dart';
import '../../../shared/widgets/common/pagination_bar.dart';
import '../providers/asset_provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markets'),
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
                        ? 'No assets found'
                        : 'No results for "${filter.search}"',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
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

