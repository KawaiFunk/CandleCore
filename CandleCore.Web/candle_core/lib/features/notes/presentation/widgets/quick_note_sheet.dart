import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../asset_list/data/asset_model.dart';
import 'note_text_field.dart';
import 'sheet_actions.dart';

class QuickNoteSheet extends StatefulWidget {
  final DetailedAssetModel asset;
  final Future<void> Function(String title, String body) onSave;

  const QuickNoteSheet({
    super.key,
    required this.asset,
    required this.onSave,
  });

  @override
  State<QuickNoteSheet> createState() => _QuickNoteSheetState();
}

class _QuickNoteSheetState extends State<QuickNoteSheet> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
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
    await widget.onSave(title, body);
    if (mounted) Navigator.pop(context);
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
                  'New Note',
                  style: TextStyle(
                    fontSize: AppTypography.textLg,
                    fontWeight: AppTypography.fontWeightSemiBold,
                  ),
                ),
              ),
              _AssetBadge(symbol: widget.asset.symbol),
            ],
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
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.trending_up, size: 12, color: AppColors.primary),
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
