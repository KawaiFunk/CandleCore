import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/config/app_config.dart';
import 'core/config/env.dart';
import 'core/providers/preferences_provider.dart';
import 'core/services/fcm_service.dart';
import 'firebase_options.dart';

final fcmTokenProvider = Provider<String?>((ref) => null);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final fcmService = FcmService();
  fcmService.registerBackgroundHandler();
  await fcmService.requestPermission();
  final fcmToken = await fcmService.getToken();

  final config = AppConfig.fromEnv();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        sharedPreferencesProvider.overrideWithValue(prefs),
        fcmTokenProvider.overrideWithValue(fcmToken),
      ],
      child: const App(),
    ),
  );
}
