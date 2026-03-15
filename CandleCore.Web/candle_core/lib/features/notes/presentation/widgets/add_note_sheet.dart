import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../asset_list/data/asset_model.dart';
import 'asset_picker_sheet.dart';
import 'note_text_field.dart';
import 'sheet_actions.dart';

class AddNoteSheet extends ConsumerStatefulWidget {
  final Future<void> Function(String title, String body, int? assetId) onSave;

  const AddNoteSheet({super.key, required this.onSave});

  @override
  ConsumerState<AddNoteSheet> createState() => _AddNoteSheetState();
}

class _AddNoteSheetState extends ConsumerState<AddNoteSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  AssetModel? _selectedAsset;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty) return;

    setState(() => _saving = true);
    await widget.onSave(title, body, _selectedAsset?.id);
    if (mounted) Navigator.pop(context);
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
            'New Note',
            style: TextStyle(
              fontSize: AppTypography.textLg,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          NoteTextField(
            controller: _titleController,
            hint: 'Title',
            isDark: isDark,
            maxLines: 1,
            autofocus: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          NoteTextField(
            controller: _bodyController,
            hint: 'Write your note...',
            isDark: isDark,
            maxLines: 4,
          ),
          const SizedBox(height: AppSpacing.sm),
          _AssetLinkRow(
            isDark: isDark,
            selectedAsset: _selectedAsset,
            onTap: _pickAsset,
            onClear: () => setState(() => _selectedAsset = null),
          ),
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

class _AssetLinkRow extends StatelessWidget {
  final bool isDark;
  final AssetModel? selectedAsset;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _AssetLinkRow({
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
            const Icon(Icons.link, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: selectedAsset == null
                  ? const Text(
                      'Link an asset (optional)',
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
