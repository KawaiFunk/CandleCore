import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';

final selectedBottomNavIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavItem {
  final String route;
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const BottomNavItem({
    required this.route,
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      route: AppRoutes.dashboard,
      icon: CupertinoIcons.home,
      activeIcon: CupertinoIcons.house_fill,
      label: 'Dashboard',
    ),
    BottomNavItem(
      route: AppRoutes.markets,
      icon: CupertinoIcons.chart_bar,
      activeIcon: CupertinoIcons.chart_bar_fill,
      label: 'Markets',
    ),
    BottomNavItem(
      route: AppRoutes.favorites,
      icon: CupertinoIcons.star,
      activeIcon: CupertinoIcons.star_fill,
      label: 'Favorites',
    ),
    BottomNavItem(
      route: AppRoutes.profile,
      icon: CupertinoIcons.person,
      activeIcon: CupertinoIcons.person_fill,
      label: 'Profile',
    ),
    BottomNavItem(
      route: AppRoutes.settings,
      icon: CupertinoIcons.settings,
      activeIcon: CupertinoIcons.settings_solid,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(selectedBottomNavIndexProvider);

    _syncWithCurrentRoute(context, ref);

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex.clamp(0, _navItems.length - 1),
        onTap: (index) => _onTabTapped(context, ref, index),
        elevation: 8,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        items: _navItems.map((item) {
          final index = _navItems.indexOf(item);
          final isSelected = index == currentIndex;

          return BottomNavigationBarItem(
            icon: Icon(
              isSelected && item.activeIcon != null
                  ? item.activeIcon
                  : item.icon,
            ),
            label: item.label,
            tooltip: item.label,
          );
        }).toList(),
      ),
    );
  }

  void _onTabTapped(BuildContext context, WidgetRef ref, int index) {
    if (index < 0 || index >= _navItems.length) {
      debugPrint('Invalid bottom nav index: $index');
      return;
    }

    try {
      ref.read(selectedBottomNavIndexProvider.notifier).state = index;
      final route = _navItems[index].route;
      context.go(route);
    } catch (e, stackTrace) {
      debugPrint('Bottom nav navigation error: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  void _syncWithCurrentRoute(BuildContext context, WidgetRef ref) {
    final currentLocation = GoRouterState.of(context).uri.path;
    final routeIndex = _navItems.indexWhere(
          (item) =>
      currentLocation == item.route ||
          currentLocation.startsWith('${item.route}/'),
    );

    if (routeIndex != -1) {
      final currentIndex = ref.read(selectedBottomNavIndexProvider);
      if (currentIndex != routeIndex) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ref.read(selectedBottomNavIndexProvider.notifier).state =
                routeIndex;
          }
        });
      }
    }
  }
}
