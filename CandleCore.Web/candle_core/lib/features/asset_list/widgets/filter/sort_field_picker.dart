import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../providers/asset_provider.dart';

class SortFieldPicker extends StatelessWidget {
  final AssetSortField selected;
  final ValueChanged<AssetSortField> onChanged;
  final Color chipBg;

  const SortFieldPicker({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.chipBg,
  });

  @override
  Widget build(BuildContext context) {
    const options = [
      (AssetSortField.rank, Icons.leaderboard_rounded, 'Rank'),
      (AssetSortField.price, Icons.attach_money_rounded, 'Price'),
      (AssetSortField.change, Icons.show_chart_rounded, '1h Change'),
      (AssetSortField.name, Icons.sort_by_alpha_rounded, 'Name'),
      (AssetSortField.marketcap, Icons.bar_chart_rounded, 'Market Cap'),
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: options.map((opt) {
        final (field, icon, label) = opt;
        final isSelected = selected == field;
        return GestureDetector(
          onTap: () => onChanged(field),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : chipBg,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppTypography.textSm,
                    fontWeight: AppTypography.fontWeightMedium,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
