import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/tokens.dart';
import '../../../asset_list/data/asset_model.dart';
import '../../../notes/presentation/widgets/asset_picker_sheet.dart';
import '../../../notes/presentation/widgets/sheet_actions.dart';
import '../../data/trigger_model.dart';
import 'trigger_condition_toggle.dart';

class AddTriggerSheet extends ConsumerStatefulWidget {
  final Future<void> Function(int assetId, AlarmCondition condition, double targetPrice) onSave;

  const AddTriggerSheet({super.key, required this.onSave});

  @override
  ConsumerState<AddTriggerSheet> createState() => _AddTriggerSheetState();
}

class _AddTriggerSheetState extends ConsumerState<AddTriggerSheet> {
  final _priceController = TextEditingController();
  AssetModel? _selectedAsset;
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
    if (_selectedAsset == null || priceText.isEmpty) return;

    final price = double.tryParse(priceText);
    if (price == null || price <= 0) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await widget.onSave(_selectedAsset!.id, _condition, price);
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

  void _pickAsset() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AssetPickerSheet(
        onSelected: (asset) => setState(() => _selectedAsset = asset),
      ),
    );
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
          const Text(
            'New Price Alert',
            style: TextStyle(
              fontSize: AppTypography.textLg,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _AssetPickRow(
            isDark: isDark,
            selectedAsset: _selectedAsset,
            onTap: _pickAsset,
            onClear: () => setState(() => _selectedAsset = null),
          ),
          const SizedBox(height: AppSpacing.sm),
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

class _AssetPickRow extends StatelessWidget {
  final bool isDark;
  final AssetModel? selectedAsset;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _AssetPickRow({
    required this.isDark,
    required this.selectedAsset,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.inputBackgroundDark
              : AppColors.inputBackgroundLight,
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: selectedAsset == null
                  ? const Text(
                      'Select asset',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppTypography.textSm,
                      ),
                    )
                  : Text(
                      '${selectedAsset!.symbol} — ${selectedAsset!.name}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: AppTypography.textSm,
                        fontWeight: AppTypography.fontWeightSemiBold,
                      ),
                    ),
            ),
            if (selectedAsset != null)
              GestureDetector(
                onTap: onClear,
                child: const Icon(Icons.close,
                    size: 16, color: AppColors.textSecondary),
              ),
          ],
        ),
      ),
    );
  }
}
