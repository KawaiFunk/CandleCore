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

class AssetListFilter {
  final int page;
  final int pageSize;
  final String search;

  const AssetListFilter({
    this.page = AppConstants.defaultPage,
    this.pageSize = AppConstants.defaultPageSize,
    this.search = '',
  });

  AssetListFilter copyWith({int? page, int? pageSize, String? search}) {
    return AssetListFilter(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      search: search ?? this.search,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AssetListFilter &&
      other.page == page &&
      other.pageSize == pageSize &&
      other.search == search;

  @override
  int get hashCode => Object.hash(page, pageSize, search);
}

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
  return service.fetchAssets(PagedListFilter(
    pageNumber: filter.page,
    pageSize: filter.pageSize,
    search: filter.search.isEmpty ? null : filter.search,
  ));
});

final refreshableAssetListProvider =
    FutureProvider.family<PagedList<AssetModel>, int>((ref, page) async {
  ref.watch(autoRefreshProvider);
  ref.watch(assetRefreshProvider);

  final service = ref.watch(assetServiceProvider);
  return service.fetchAssets(PagedListFilter(
    pageNumber: page,
    pageSize: AppConstants.defaultPageSize,
  ));
});
