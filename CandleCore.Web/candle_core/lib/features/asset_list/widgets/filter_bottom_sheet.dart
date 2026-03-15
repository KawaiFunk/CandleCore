import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../providers/asset_provider.dart';

void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _FilterSheet(),
  );
}

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet();

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  late AssetSortField _sortBy;
  late AssetSortDirection _sortDirection;
  late AssetChangeFilter _changeFilter;
  late RangeValues _priceRange;
  late bool _hasPriceFilter;

  static const double _sliderMax = 100000.0;

  @override
  void initState() {
    super.initState();
    final f = ref.read(assetListFilterProvider);
    _sortBy = f.sortBy;
    _sortDirection = f.sortDirection;
    _changeFilter = f.changeFilter;
    _hasPriceFilter = f.priceMin != null || f.priceMax != null;
    _priceRange = RangeValues(f.priceMin ?? 0, f.priceMax ?? _sliderMax);
  }

  void _apply() {
    ref.read(assetListFilterProvider.notifier).applyFilters(
          sortBy: _sortBy,
          sortDirection: _sortDirection,
          changeFilter: _changeFilter,
          priceMin: _hasPriceFilter ? _priceRange.start : null,
          priceMax: _hasPriceFilter && _priceRange.end < _sliderMax
              ? _priceRange.end
              : null,
        );
    Navigator.pop(context);
  }

  void _reset() {
    setState(() {
      _sortBy = AssetSortField.rank;
      _sortDirection = AssetSortDirection.asc;
      _changeFilter = AssetChangeFilter.all;
      _hasPriceFilter = false;
      _priceRange = const RangeValues(0, _sliderMax);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final chipBg = isDark ? AppColors.secondaryDark : AppColors.secondaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _Handle(borderColor: borderColor),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    0,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  children: [
                    _SheetHeader(onReset: _reset),
                    const SizedBox(height: AppSpacing.lg),
                    const _SectionLabel('Sort by'),
                    const SizedBox(height: AppSpacing.sm),
                    _SortFieldPicker(
                      selected: _sortBy,
                      onChanged: (f) => setState(() => _sortBy = f),
                      chipBg: chipBg,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const _SectionLabel('Order'),
                    const SizedBox(height: AppSpacing.sm),
                    _ToggleRow<AssetSortDirection>(
                      values: AssetSortDirection.values,
                      selected: _sortDirection,
                      label: (v) => v == AssetSortDirection.asc ? 'Ascending' : 'Descending',
                      icon: (v) => v == AssetSortDirection.asc
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      onChanged: (v) => setState(() => _sortDirection = v),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const _SectionLabel('Movement'),
                    const SizedBox(height: AppSpacing.sm),
                    _ToggleRow<AssetChangeFilter>(
                      values: AssetChangeFilter.values,
                      selected: _changeFilter,
                      label: (v) => switch (v) {
                        AssetChangeFilter.all => 'All',
                        AssetChangeFilter.gainers => 'Gainers',
                        AssetChangeFilter.losers => 'Losers',
                      },
                      icon: (v) => switch (v) {
                        AssetChangeFilter.all => Icons.swap_vert_rounded,
                        AssetChangeFilter.gainers => Icons.trending_up_rounded,
                        AssetChangeFilter.losers => Icons.trending_down_rounded,
                      },
                      onChanged: (v) => setState(() => _changeFilter = v),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _SectionLabel('Price Range (USD)'),
                        Switch(
                          value: _hasPriceFilter,
                          activeColor: AppColors.primary,
                          onChanged: (v) => setState(() => _hasPriceFilter = v),
                        ),
                      ],
                    ),
                    if (_hasPriceFilter) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _PriceRangeSlider(
                        range: _priceRange,
                        max: _sliderMax,
                        chipBg: chipBg,
                        onChanged: (r) => setState(() => _priceRange = r),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    _ApplyButton(onPressed: _apply),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Handle extends StatelessWidget {
  final Color borderColor;
  const _Handle({required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: borderColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final VoidCallback onReset;
  const _SheetHeader({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filter & Sort',
          style: TextStyle(
            fontSize: AppTypography.textLg,
            fontWeight: AppTypography.fontWeightBold,
          ),
        ),
        TextButton(
          onPressed: onReset,
          child: const Text(
            'Reset',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: AppTypography.textSm,
        fontWeight: AppTypography.fontWeightSemiBold,
        color: AppColors.textSecondary,
        letterSpacing: AppTypography.letterSpacingWide,
      ),
    );
  }
}

class _SortFieldPicker extends StatelessWidget {
  final AssetSortField selected;
  final ValueChanged<AssetSortField> onChanged;
  final Color chipBg;

  const _SortFieldPicker({
    required this.selected,
    required this.onChanged,
    required this.chipBg,
  });

  @override
  Widget build(BuildContext context) {
    const options = [
      (AssetSortField.rank, Icons.leaderboard_rounded, 'Rank'),
      (AssetSortField.price, Icons.attach_money_rounded, 'Price'),
      (AssetSortField.change, Icons.show_chart_rounded, '1h Change'),
      (AssetSortField.name, Icons.sort_by_alpha_rounded, 'Name'),
      (AssetSortField.marketcap, Icons.bar_chart_rounded, 'Market Cap'),
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: options.map((opt) {
        final (field, icon, label) = opt;
        final isSelected = selected == field;
        return GestureDetector(
          onTap: () => onChanged(field),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : chipBg,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppTypography.textSm,
                    fontWeight: AppTypography.fontWeightMedium,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ToggleRow<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final String Function(T) label;
  final IconData Function(T) icon;
  final ValueChanged<T> onChanged;

  const _ToggleRow({
    required this.values,
    required this.selected,
    required this.label,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.secondaryDark : AppColors.secondaryLight;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: values.map((v) {
          final isSelected = selected == v;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon(v),
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label(v),
                      style: TextStyle(
                        fontSize: AppTypography.textXs,
                        fontWeight: AppTypography.fontWeightMedium,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PriceRangeSlider extends StatelessWidget {
  final RangeValues range;
  final double max;
  final Color chipBg;
  final ValueChanged<RangeValues> onChanged;

  const _PriceRangeSlider({
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
              _PriceLabel(label: 'Min', value: _fmt(range.start)),
              _PriceLabel(
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
              rangeThumbShape:
                  const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
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

class _PriceLabel extends StatelessWidget {
  final String label;
  final String value;
  const _PriceLabel({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: AppTypography.textXs,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: AppTypography.textSm,
            fontWeight: AppTypography.fontWeightSemiBold,
          ),
        ),
      ],
    );
  }
}

class _ApplyButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _ApplyButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
        ),
        child: const Text(
          'Apply Filters',
          style: TextStyle(
            color: Colors.white,
            fontWeight: AppTypography.fontWeightSemiBold,
            fontSize: AppTypography.textBase,
          ),
        ),
      ),
    );
  }
}
