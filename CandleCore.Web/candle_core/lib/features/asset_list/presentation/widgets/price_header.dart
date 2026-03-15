import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../data/detailed_asset_model.dart';

class PriceHeader extends StatelessWidget {
  final DetailedAssetModel asset;
  final Color changeColor;
  final bool isPositive;

  const PriceHeader({
    super.key,
    required this.asset,
    required this.changeColor,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Price',
                style: TextStyle(
                  fontSize: AppTypography.textSm,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${_formatPrice(asset.priceUsd)}',
                style: const TextStyle(
                  fontSize: AppTypography.text3xl,
                  fontWeight: AppTypography.fontWeightBold,
                  letterSpacing: AppTypography.letterSpacingTight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₿ ${_formatBtc(asset.priceBtc)}',
                style: const TextStyle(
                  fontSize: AppTypography.textSm,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: changeColor.withAlpha(20),
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: changeColor.withAlpha(60)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 16,
                color: changeColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${asset.percentChange1h.abs().toStringAsFixed(2)}%',
                style: TextStyle(
                  color: changeColor,
                  fontWeight: AppTypography.fontWeightBold,
                  fontSize: AppTypography.textBase,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      return price
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );
    }
    if (price >= 1) return price.toStringAsFixed(2);
    return price.toStringAsFixed(6);
  }

  String _formatBtc(double btc) {
    if (btc == 0) return '0';
    if (btc < 0.00001) return btc.toStringAsExponential(2);
    return btc.toStringAsFixed(8);
  }
}
