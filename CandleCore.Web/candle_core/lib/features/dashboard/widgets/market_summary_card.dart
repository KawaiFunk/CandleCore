import 'package:flutter/material.dart';
import '../../../core/theme/tokens.dart';

class MarketSummaryCard extends StatelessWidget {
  final int totalAssets;
  final int gainCount;
  final int lossCount;
  final double avgChange;

  const MarketSummaryCard({
    super.key,
    required this.totalAssets,
    required this.gainCount,
    required this.lossCount,
    required this.avgChange,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = avgChange >= 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withAlpha(180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadii.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Market Overview',
            style: TextStyle(
              color: Colors.white70,
              fontSize: AppTypography.textSm,
              fontWeight: AppTypography.fontWeightMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : ''}${avgChange.toStringAsFixed(2)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: AppTypography.text4xl,
                  fontWeight: AppTypography.fontWeightBold,
                  letterSpacing: AppTypography.letterSpacingTight,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  'avg 1h change',
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: AppTypography.textXs,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _StatChip(
                label: '$totalAssets tracked',
                icon: Icons.bar_chart,
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatChip(
                label: '$gainCount up',
                icon: Icons.trending_up,
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatChip(
                label: '$lossCount down',
                icon: Icons.trending_down,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: AppTypography.textXs,
              fontWeight: AppTypography.fontWeightMedium,
            ),
          ),
        ],
      ),
    );
  }
}
