import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../triggers/data/trigger_model.dart';

class TriggerPreviewCard extends StatelessWidget {
  final TriggerModel trigger;
  final VoidCallback onToggle;

  const TriggerPreviewCard({
    super.key,
    required this.trigger,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAbove = trigger.condition == AlarmCondition.above;
    final conditionColor = isAbove ? AppColors.primary : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 4,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trigger.assetName,
                  style: const TextStyle(
                    fontWeight: AppTypography.fontWeightSemiBold,
                    fontSize: AppTypography.textBase,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Icon(
                      isAbove ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: conditionColor,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${isAbove ? 'Above' : 'Below'} \$${_formatPrice(trigger.targetPrice)}',
                      style: TextStyle(
                        color: conditionColor,
                        fontSize: AppTypography.textXs,
                        fontWeight: AppTypography.fontWeightSemiBold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: trigger.isActive,
            onChanged: (_) => onToggle(),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    if (price >= 1) return price.toStringAsFixed(2);
    return price.toStringAsFixed(6);
  }
}
