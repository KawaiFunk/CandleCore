import '../../../core/config/env.dart';
import '../../../core/network/http_client.dart';
import 'note_model.dart';

class NoteService {
  late final ApiHttpClient _client;

  NoteService() {
    _client = ApiHttpClient(
      Env.get('API_BASE_URL', fallback: 'http://10.0.2.2:5106'),
    );
  }

  Future<List<NoteModel>> getNotes(int userId) async {
    final json = await _client.get('/api/notes/$userId');
    final list = json as List<dynamic>;
    return list.map((e) => NoteModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<NoteModel> createNote({
    required int userId,
    required String title,
    required String body,
    int? assetId,
  }) async {
    final json = await _client.post(
      '/api/notes/$userId',
      body: {
        'title': title,
        'body': body,
        if (assetId != null) 'assetId': assetId,
      },
    );
    return NoteModel.fromJson(json as Map<String, dynamic>);
  }

  Future<void> deleteNote(int userId, int noteId) async {
    await _client.delete('/api/notes/$userId/$noteId');
  }
}
