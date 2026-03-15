import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/constants.dart';
import '../../../core/models/paged_list.dart';
import '../data/asset_model.dart';
import '../data/asset_service.dart';

final assetServiceProvider = Provider((ref) => AssetService());

final autoRefreshProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});

final assetRefreshProvider =
    NotifierProvider<AssetRefreshNotifier, int>(AssetRefreshNotifier.new);

class AssetRefreshNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void refresh() => state++;
}

enum AssetSortField { rank, price, change, name, marketcap }

enum AssetSortDirection { asc, desc }

enum AssetChangeFilter { all, gainers, losers }

class AssetListFilter {
  final int page;
  final int pageSize;
  final String search;
  final AssetSortField sortBy;
  final AssetSortDirection sortDirection;
  final AssetChangeFilter changeFilter;
  final double? priceMin;
  final double? priceMax;

  const AssetListFilter({
    this.page = AppConstants.defaultPage,
    this.pageSize = AppConstants.defaultPageSize,
    this.search = '',
    this.sortBy = AssetSortField.rank,
    this.sortDirection = AssetSortDirection.asc,
    this.changeFilter = AssetChangeFilter.all,
    this.priceMin,
    this.priceMax,
  });

  int get activeFilterCount {
    int count = 0;
    if (sortBy != AssetSortField.rank || sortDirection != AssetSortDirection.asc) count++;
    if (changeFilter != AssetChangeFilter.all) count++;
    if (priceMin != null || priceMax != null) count++;
    return count;
  }

  AssetListFilter copyWith({
    int? page,
    int? pageSize,
    String? search,
    AssetSortField? sortBy,
    AssetSortDirection? sortDirection,
    AssetChangeFilter? changeFilter,
    Object? priceMin = _sentinel,
    Object? priceMax = _sentinel,
  }) {
    return AssetListFilter(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      search: search ?? this.search,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      changeFilter: changeFilter ?? this.changeFilter,
      priceMin: priceMin == _sentinel ? this.priceMin : priceMin as double?,
      priceMax: priceMax == _sentinel ? this.priceMax : priceMax as double?,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AssetListFilter &&
      other.page == page &&
      other.pageSize == pageSize &&
      other.search == search &&
      other.sortBy == sortBy &&
      other.sortDirection == sortDirection &&
      other.changeFilter == changeFilter &&
      other.priceMin == priceMin &&
      other.priceMax == priceMax;

  @override
  int get hashCode => Object.hash(
        page,
        pageSize,
        search,
        sortBy,
        sortDirection,
        changeFilter,
        priceMin,
        priceMax,
      );
}

const _sentinel = Object();

final assetListFilterProvider =
    NotifierProvider<AssetListFilterNotifier, AssetListFilter>(
        AssetListFilterNotifier.new);

class AssetListFilterNotifier extends Notifier<AssetListFilter> {
  @override
  AssetListFilter build() => const AssetListFilter();

  void setSearch(String search) {
    state = state.copyWith(search: search, page: AppConstants.defaultPage);
  }

  void setPage(int page) {
    state = state.copyWith(page: page);
  }

  void setSortBy(AssetSortField sortBy) {
    if (state.sortBy == sortBy) {
      final toggled = state.sortDirection == AssetSortDirection.asc
          ? AssetSortDirection.desc
          : AssetSortDirection.asc;
      state = state.copyWith(sortDirection: toggled, page: AppConstants.defaultPage);
    } else {
      state = state.copyWith(
        sortBy: sortBy,
        sortDirection: AssetSortDirection.desc,
        page: AppConstants.defaultPage,
      );
    }
  }

  void applyFilters({
    required AssetSortField sortBy,
    required AssetSortDirection sortDirection,
    required AssetChangeFilter changeFilter,
    double? priceMin,
    double? priceMax,
  }) {
    state = state.copyWith(
      sortBy: sortBy,
      sortDirection: sortDirection,
      changeFilter: changeFilter,
      priceMin: priceMin,
      priceMax: priceMax,
      page: AppConstants.defaultPage,
    );
  }

  void resetFilters() {
    state = AssetListFilter(
      page: AppConstants.defaultPage,
      pageSize: state.pageSize,
      search: state.search,
    );
  }

  void reset() {
    state = const AssetListFilter();
  }
}

final pagedAssetListProvider =
    FutureProvider.family<PagedList<AssetModel>, AssetListFilter>(
        (ref, filter) async {
  ref.watch(autoRefreshProvider);
  ref.watch(assetRefreshProvider);

  final service = ref.watch(assetServiceProvider);
  return service.fetchAssets(filter);
});

final refreshableAssetListProvider =
    FutureProvider.family<PagedList<AssetModel>, int>((ref, page) async {
  ref.watch(autoRefreshProvider);
  ref.watch(assetRefreshProvider);

  final service = ref.watch(assetServiceProvider);
  return service.fetchAssets(AssetListFilter(
    page: page,
    pageSize: AppConstants.defaultPageSize,
  ));
});
