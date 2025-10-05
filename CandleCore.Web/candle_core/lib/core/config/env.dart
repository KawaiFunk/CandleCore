import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async {
    await dotenv.load(
      fileName: const String.fromEnvironment('ENV_FILE', defaultValue: '.env'),
    );
  }

  static String get(String key, {String fallback = ''}) {
    return dotenv.env[key] ?? fallback;
  }
}
