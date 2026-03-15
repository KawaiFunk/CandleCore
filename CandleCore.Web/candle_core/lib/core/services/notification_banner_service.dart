import 'package:flutter/material.dart';

import '../widgets/notification_banner.dart';

class NotificationBannerService {
  static final NotificationBannerService _instance =
      NotificationBannerService._internal();

  factory NotificationBannerService() => _instance;

  NotificationBannerService._internal();

  final navigatorKey = GlobalKey<NavigatorState>();

  OverlayEntry? _entry;

  void show({required String title, required String body, VoidCallback? onTap}) {
    _dismiss();

    final overlay = navigatorKey.currentState?.overlay;
    if (overlay == null) return;

    _entry = OverlayEntry(
      builder: (_) => NotificationBanner(
        title: title,
        body: body,
        onTap: () {
          _dismiss();
          onTap?.call();
        },
        onDismiss: _dismiss,
      ),
    );

    overlay.insert(_entry!);

    Future.delayed(const Duration(seconds: 4), _dismiss);
  }

  void _dismiss() {
    _entry?.remove();
    _entry = null;
  }
}
