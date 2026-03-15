import 'package:flutter/material.dart';
import '../../../core/theme/tokens.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavButton(
            icon: Icons.arrow_back_ios_new_rounded,
            enabled: hasPrevious,
            onTap: hasPrevious ? onPrevious : null,
            isDark: isDark,
          ),
          _PageIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
            isDark: isDark,
          ),
          _NavButton(
            icon: Icons.arrow_forward_ios_rounded,
            enabled: hasNext,
            onTap: hasNext ? onNext : null,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;
  final bool isDark;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.primary
              : isDark
                  ? AppColors.secondaryDark
                  : AppColors.secondaryLight,
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        child: Icon(
          icon,
          size: 14,
          color: enabled ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final bool isDark;

  const _PageIndicator({
    required this.currentPage,
    required this.totalPages,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final pages = _buildPageNumbers();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: pages.map((p) {
        if (p == null) return _Ellipsis(isDark: isDark);
        return _PageButton(
          page: p,
          isActive: p == currentPage,
          isDark: isDark,
        );
      }).toList(),
    );
  }

  List<int?> _buildPageNumbers() {
    if (totalPages <= 5) {
      return List.generate(totalPages, (i) => i + 1);
    }

    final result = <int?>[];

    result.add(1);

    if (currentPage > 3) result.add(null);

    for (var p = (currentPage - 1).clamp(2, totalPages - 1);
        p <= (currentPage + 1).clamp(2, totalPages - 1);
        p++) {
      result.add(p);
    }

    if (currentPage < totalPages - 2) result.add(null);

    result.add(totalPages);

    return result;
  }
}

class _PageButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final bool isDark;

  const _PageButton({
    required this.page,
    required this.isActive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withAlpha(20)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: isActive
              ? Border.all(color: AppColors.primary.withAlpha(80))
              : null,
        ),
        child: Center(
          child: Text(
            '$page',
            style: TextStyle(
              fontSize: AppTypography.textSm,
              fontWeight: isActive
                  ? AppTypography.fontWeightBold
                  : AppTypography.fontWeightNormal,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  final bool isDark;
  const _Ellipsis({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: SizedBox(
        width: 36,
        height: 36,
        child: Center(
          child: Text(
            '···',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.textSm,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
