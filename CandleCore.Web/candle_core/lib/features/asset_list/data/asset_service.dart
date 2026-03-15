import '../../../core/config/env.dart';
import '../../../core/models/paged_list.dart';
import '../../../core/network/http_client.dart';
import 'asset_model.dart';

class AssetService {
  late final ApiHttpClient _client;

  AssetService() {
    _client = ApiHttpClient(
      Env.get('API_BASE_URL', fallback: 'http://10.0.2.2:5106'),
    );
  }

  Future<PagedList<AssetModel>> fetchAssets(PagedListFilter filter) async {
    final params = {
      'pageNumber': '${filter.pageNumber}',
      'pageSize':   '${filter.pageSize}',
      if (filter.search != null && filter.search!.isNotEmpty)
        'search': filter.search!,
    };

    final json = await _client.get('/api/assets', queryParams: params);
    return PagedList.fromJson(
      json as Map<String, dynamic>,
      (e) => AssetModel.fromJson(e as Map<String, dynamic>),
    );
  }
}
