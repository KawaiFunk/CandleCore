import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../routing/routes.dart';

final selectedBottomNavIndexProvider =
    NotifierProvider<SelectedNavIndexNotifier, int>(
        SelectedNavIndexNotifier.new);

class SelectedNavIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

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
      route: AppRoutes.notes,
      icon: CupertinoIcons.doc_text,
      activeIcon: CupertinoIcons.doc_text_fill,
      label: 'Notes',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    _syncWithCurrentRoute(context, ref);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex.clamp(0, _navItems.length - 1),
        onTap: (index) => _onTabTapped(context, ref, index),
        elevation: 0,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        items: _navItems.map((item) {
          final index = _navItems.indexOf(item);
          final isSelected = index == currentIndex;

          return BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withAlpha(30)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isSelected && item.activeIcon != null
                    ? item.activeIcon
                    : item.icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 22,
              ),
            ),
            label: item.label,
            tooltip: item.label,
          );
        }).toList(),
      ),
    );
  }

  void _onTabTapped(BuildContext context, WidgetRef ref, int index) {
    if (index < 0 || index >= _navItems.length) return;
    ref.read(selectedBottomNavIndexProvider.notifier).setIndex(index);
    context.go(_navItems[index].route);
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
            ref.read(selectedBottomNavIndexProvider.notifier).setIndex(routeIndex);
          }
        });
      }
    }
  }
}
