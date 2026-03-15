import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import 'price_label.dart';

class PriceRangeSlider extends StatelessWidget {
  final RangeValues range;
  final double max;
  final Color chipBg;
  final ValueChanged<RangeValues> onChanged;

  const PriceRangeSlider({
    super.key,
    required this.range,
    required this.max,
    required this.chipBg,
    required this.onChanged,
  });

  String _fmt(double v) {
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(0)}K';
    if (v >= 1) return '\$${v.toStringAsFixed(0)}';
    return '\$${v.toStringAsFixed(4)}';
  }

  @override
  Widget build(BuildContext context) {
    final atMax = range.end >= max;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PriceLabel(label: 'Min', value: _fmt(range.start)),
              PriceLabel(
                label: 'Max',
                value: atMax ? '${_fmt(max)}+' : _fmt(range.end),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.primary.withAlpha(40),
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withAlpha(30),
              rangeThumbShape: const RoundRangeSliderThumbShape(
                enabledThumbRadius: 10,
              ),
            ),
            child: RangeSlider(
              values: range,
              min: 0,
              max: max,
              divisions: 200,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
