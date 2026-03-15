import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../data/note_model.dart';
import 'note_asset_chip.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onDelete;

  const NoteCard({super.key, required this.note, required this.onDelete});

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
                      note.title,
                      style: const TextStyle(
                        fontWeight: AppTypography.fontWeightSemiBold,
                        fontSize: AppTypography.textBase,
                      ),
                    ),
                    if (note.assetSymbol != null && note.assetId != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      NoteAssetChip(
                        assetId: note.assetId!,
                        symbol: note.assetSymbol!,
                      ),
                    ],
                  ],
                ),
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
          if (note.body.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              note.body,
              style: const TextStyle(
                fontSize: AppTypography.textSm,
                height: AppTypography.lineHeightNormal,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            _formatDate(note.createdAtUtc.toLocal()),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppTypography.textXs,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}  '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
