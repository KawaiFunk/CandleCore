import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'env.dart';

class AppConfig {
  final String apiBaseUrl;
  final bool enableLogging;

  AppConfig({required this.apiBaseUrl, required this.enableLogging});

  factory AppConfig.fromEnv() {
    return AppConfig(
      apiBaseUrl: Env.get('API_BASE_URL', fallback: 'https://api.example.com'),
      enableLogging: Env.get('DEBUG_LOGS', fallback: 'false') == 'true',
    );
  }
}

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('AppConfig has not been initialized');
});
