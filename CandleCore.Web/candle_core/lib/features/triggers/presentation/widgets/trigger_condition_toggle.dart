import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../data/trigger_model.dart';

class TriggerConditionToggle extends StatelessWidget {
  final AlarmCondition value;
  final ValueChanged<AlarmCondition> onChanged;

  const TriggerConditionToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        _ConditionButton(
          label: 'Above',
          selected: value == AlarmCondition.above,
          isDark: isDark,
          onTap: () => onChanged(AlarmCondition.above),
        ),
        const SizedBox(width: AppSpacing.sm),
        _ConditionButton(
          label: 'Below',
          selected: value == AlarmCondition.below,
          isDark: isDark,
          onTap: () => onChanged(AlarmCondition.below),
        ),
      ],
    );
  }
}

class _ConditionButton extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _ConditionButton({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary
                : (isDark
                    ? AppColors.inputBackgroundDark
                    : AppColors.inputBackgroundLight),
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: AppTypography.textSm,
                fontWeight: AppTypography.fontWeightSemiBold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
