import '../../../core/config/env.dart';
import '../../../core/network/http_client.dart';
import '../../asset_list/data/asset_model.dart';

class FavoriteService {
  late final ApiHttpClient _client;

  FavoriteService() {
    _client = ApiHttpClient(
      Env.get('API_BASE_URL', fallback: 'http://10.0.2.2:5106'),
    );
  }

  Future<List<AssetModel>> getFavorites(int userId) async {
    final json = await _client.get('/api/favorites/$userId');
    final list = json as List<dynamic>;
    return list.map((e) => AssetModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<bool> toggleFavorite(int userId, int assetId) async {
    final json = await _client.post('/api/favorites/$userId/$assetId', body: {});
    return (json as Map<String, dynamic>)['isFavorite'] as bool;
  }
}
