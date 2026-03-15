import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/notification_banner_service.dart';
import '../core/theme/app_theme.dart';
import '../features/theme/providers/theme_provider.dart';
import '../features/triggers/providers/triggers_provider.dart';
import '../routing/app_router.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      NotificationBannerService().show(
        title: title,
        body: body,
        onTap: () => ref.invalidate(triggersProvider),
      );
      ref.invalidate(triggersProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'CandleCore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
