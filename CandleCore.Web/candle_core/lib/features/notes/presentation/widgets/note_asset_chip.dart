import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../routing/routes.dart';

class NoteAssetChip extends StatelessWidget {
  final int assetId;
  final String symbol;

  const NoteAssetChip({super.key, required this.assetId, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.assetDetailPath(assetId)),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: 2),
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
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 10, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
