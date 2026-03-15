import 'package:flutter/material.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/tokens.dart';
import '../../../notes/presentation/widgets/sheet_actions.dart';
import '../../data/trigger_model.dart';
import 'trigger_condition_toggle.dart';

class QuickTriggerSheet extends StatefulWidget {
  final int assetId;
  final String assetName;
  final String assetSymbol;
  final Future<void> Function(AlarmCondition condition, double targetPrice) onSave;

  const QuickTriggerSheet({
    super.key,
    required this.assetId,
    required this.assetName,
    required this.assetSymbol,
    required this.onSave,
  });

  @override
  State<QuickTriggerSheet> createState() => _QuickTriggerSheetState();
}

class _QuickTriggerSheetState extends State<QuickTriggerSheet> {
  final _priceController = TextEditingController();
  AlarmCondition _condition = AlarmCondition.above;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final priceText = _priceController.text.trim();
    if (priceText.isEmpty) return;

    final price = double.tryParse(priceText);
    if (price == null || price <= 0) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await widget.onSave(_condition, price);
      if (mounted) Navigator.pop(context);
    } on ApiException catch (e) {
      if (mounted) setState(() {
        _saving = false;
        _error = e.message;
      });
    } catch (_) {
      if (mounted) setState(() {
        _saving = false;
        _error = 'Something went wrong. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: bottom + AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'New Price Alert',
                  style: TextStyle(
                    fontSize: AppTypography.textLg,
                    fontWeight: AppTypography.fontWeightSemiBold,
                  ),
                ),
              ),
              _AssetBadge(symbol: widget.assetSymbol),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TriggerConditionToggle(
            value: _condition,
            onChanged: (v) => setState(() {
              _condition = v;
              _error = null;
            }),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _priceController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: AppTypography.textBase),
            onChanged: (_) => setState(() => _error = null),
            decoration: InputDecoration(
              hintText: 'Target price (USD)',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              filled: true,
              fillColor: isDark
                  ? AppColors.inputBackgroundDark
                  : AppColors.inputBackgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _error!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: AppTypography.textXs,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SheetActions(
            saving: _saving,
            onCancel: () => Navigator.pop(context),
            onSave: _save,
          ),
        ],
      ),
    );
  }
}

class _AssetBadge extends StatelessWidget {
  final String symbol;

  const _AssetBadge({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.notifications_outlined, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            symbol,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: AppTypography.textXs,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
        ],
      ),
    );
  }
}
