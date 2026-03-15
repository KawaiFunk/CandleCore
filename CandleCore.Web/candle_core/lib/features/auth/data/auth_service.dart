import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/env.dart';
import 'auth_model.dart';

class AuthService {
  String get _baseUrl => Env.get('API_BASE_URL', fallback: 'http://10.0.2.2:5106');

  Future<UserModel> register(RegisterRequest request) async {
    final uri = Uri.parse('$_baseUrl/api/users/register');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    }

    throw Exception(response.body);
  }

  Future<UserModel> login(LoginRequest request) async {
    final uri = Uri.parse('$_baseUrl/api/users/login');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Invalid username or password.');
  }
}
