import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiHttpClient {
  final String baseUrl;

  const ApiHttpClient(this.baseUrl);

  Future<dynamic> get(String path, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParams);
    final response = await http.get(uri, headers: _headers());
    return _handle(response);
  }

  Future<dynamic> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.delete(uri, headers: _headers());
    return _handle(response);
  }

  Future<dynamic> post(String path, {required Map<String, dynamic> body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.post(
      uri,
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _handle(response);
  }

  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await http.patch(
      uri,
      headers: _headers(),
      body: body != null ? jsonEncode(body) : null,
    );
    return _handle(response);
  }

  Map<String, String> _headers() => {'Content-Type': 'application/json'};

  dynamic _handle(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      throw ApiException.fromJson(response.statusCode, json);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        statusCode: response.statusCode,
        errorCode:  'UNKNOWN',
        message:    'An unexpected error occurred.',
      );
    }
  }
}
