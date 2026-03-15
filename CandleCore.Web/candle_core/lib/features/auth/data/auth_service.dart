import '../../../core/config/env.dart';
import '../../../core/network/http_client.dart';
import 'auth_model.dart';

class AuthService {
  late final ApiHttpClient _client;

  AuthService() {
    _client = ApiHttpClient(
      Env.get('API_BASE_URL', fallback: 'http://10.0.2.2:5106'),
    );
  }

  Future<UserModel> register(RegisterRequest request) async {
    final json = await _client.post('/api/users/register', body: request.toJson());
    return UserModel.fromJson(json as Map<String, dynamic>);
  }

  Future<UserModel> login(LoginRequest request) async {
    final json = await _client.post('/api/users/login', body: request.toJson());
    return UserModel.fromJson(json as Map<String, dynamic>);
  }
}
