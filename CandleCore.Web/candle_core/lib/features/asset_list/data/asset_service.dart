import '../../../core/config/env.dart';
import '../../../core/models/paged_list.dart';
import '../../../core/network/http_client.dart';
import '../providers/asset_provider.dart';
import 'asset_model.dart';

class AssetService {
  late final ApiHttpClient _client;

  AssetService() {
    _client = ApiHttpClient(
      Env.get('API_BASE_URL', fallback: 'http://10.0.2.2:5106'),
    );
  }

  Future<PagedList<AssetModel>> fetchAssets(AssetListFilter filter) async {
    final params = <String, String>{
      'pageNumber': '${filter.page}',
      'pageSize': '${filter.pageSize}',
      if (filter.search.isNotEmpty) 'search': filter.search,
      'sortBy': _sortFieldName(filter.sortBy),
      'descending': '${filter.sortDirection == AssetSortDirection.desc}',
      if (filter.changeFilter != AssetChangeFilter.all)
        'changeFilter': _changeFilterName(filter.changeFilter),
      if (filter.priceMin != null) 'priceMin': '${filter.priceMin}',
      if (filter.priceMax != null) 'priceMax': '${filter.priceMax}',
    };

    final json = await _client.get('/api/assets', queryParams: params);
    return PagedList.fromJson(
      json as Map<String, dynamic>,
      (e) => AssetModel.fromJson(e as Map<String, dynamic>),
    );
  }

  String _sortFieldName(AssetSortField field) => switch (field) {
        AssetSortField.rank => 'Rank',
        AssetSortField.price => 'Price',
        AssetSortField.change => 'Change1h',
        AssetSortField.name => 'Name',
        AssetSortField.marketcap => 'MarketCap',
      };

  String _changeFilterName(AssetChangeFilter filter) => switch (filter) {
        AssetChangeFilter.gainers => 'Gainers',
        AssetChangeFilter.losers => 'Losers',
        AssetChangeFilter.all => 'All',
      };
}
