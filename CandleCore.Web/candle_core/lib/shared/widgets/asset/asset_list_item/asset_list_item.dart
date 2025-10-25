import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../../../features/asset_list/data/asset_model.dart';
import '../asset_illustration/asset_illustration.dart';

class AssetListItem extends StatelessWidget {
  final AssetModel asset;

  const AssetListItem({super.key, required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight, width: 1),
        borderRadius: BorderRadius.circular(8.0),
        color: AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ]
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AssetIllustration(
                    text: asset.symbol,
                    backgroundColor: AppColors.primaryLight.withAlpha(50),
                    iconColor: AppColors.primary,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.name,
                        style: TextStyle(
                          fontWeight: AppTypography.fontWeightBold,
                        ),
                      ),
                      Text(
                        asset.symbol,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: AppTypography.fontWeightMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${asset.priceUsd} \$',
                    style: TextStyle(fontWeight: AppTypography.fontWeightBold),
                  ),
                  Row(
                    children: [
                      Icon(
                        asset.percentChange1h >= 0
                            ? Icons.trending_up
                            : Icons.trending_down,
                        size: 20,
                        color: asset.percentChange1h >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${asset.percentChange1h.abs()} %',
                        style: TextStyle(
                          color: asset.percentChange1h >= 0
                              ? Colors.green
                              : Colors.red,
                          fontWeight: AppTypography.fontWeightMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
