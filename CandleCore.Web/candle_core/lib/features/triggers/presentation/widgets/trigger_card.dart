import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../data/trigger_model.dart';

class TriggerCard extends StatelessWidget {
  final TriggerModel trigger;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TriggerCard({
    super.key,
    required this.trigger,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        _ConditionBadge(condition: trigger.condition),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '\$${_formatPrice(trigger.targetPrice)}',
                          style: const TextStyle(
                            fontSize: AppTypography.textSm,
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
              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          if (trigger.triggeredAt != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _TriggeredChip(triggeredAt: trigger.triggeredAt!),
          ],
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

class _ConditionBadge extends StatelessWidget {
  final AlarmCondition condition;

  const _ConditionBadge({required this.condition});

  @override
  Widget build(BuildContext context) {
    final isAbove = condition == AlarmCondition.above;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: (isAbove ? AppColors.primary : AppColors.error).withAlpha(25),
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAbove ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: isAbove ? AppColors.primary : AppColors.error,
          ),
          const SizedBox(width: 2),
          Text(
            isAbove ? 'Above' : 'Below',
            style: TextStyle(
              color: isAbove ? AppColors.primary : AppColors.error,
              fontSize: AppTypography.textXs,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TriggeredChip extends StatelessWidget {
  final DateTime triggeredAt;

  const _TriggeredChip({required this.triggeredAt});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.withAlpha(30),
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 12, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            'Triggered',
            style: const TextStyle(
              color: Colors.amber,
              fontSize: AppTypography.textXs,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
        ],
      ),
    );
  }
}
