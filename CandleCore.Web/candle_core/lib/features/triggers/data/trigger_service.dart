import '../../../core/config/env.dart';
import '../../../core/network/http_client.dart';
import 'trigger_model.dart';

class TriggerService {
  late final ApiHttpClient _client;

  TriggerService() {
    _client = ApiHttpClient(
      Env.get('API_BASE_URL', fallback: 'http://10.0.2.2:5106'),
    );
  }

  Future<List<TriggerModel>> getTriggers(int userId) async {
    final json = await _client.get('/api/triggers/$userId');
    final list = json as List<dynamic>;
    return list
        .map((e) => TriggerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<TriggerModel> createTrigger({
    required int userId,
    required int assetId,
    required AlarmCondition condition,
    required double targetPrice,
  }) async {
    final json = await _client.post(
      '/api/triggers/$userId',
      body: {
        'assetId': assetId,
        'condition': condition == AlarmCondition.above ? 0 : 1,
        'targetPrice': targetPrice,
      },
    );
    return TriggerModel.fromJson(json as Map<String, dynamic>);
  }

  Future<TriggerModel> toggleTrigger(int userId, int triggerId) async {
    final json = await _client.patch('/api/triggers/$userId/$triggerId');
    return TriggerModel.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteTrigger(int userId, int triggerId) async {
    await _client.delete('/api/triggers/$userId/$triggerId');
  }
}
