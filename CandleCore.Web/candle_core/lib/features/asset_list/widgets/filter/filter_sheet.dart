import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../providers/asset_provider.dart';
import 'apply_button.dart';
import 'filter_handle.dart';
import 'filter_section_label.dart';
import 'filter_sheet_header.dart';
import 'price_range_slider.dart';
import 'sort_field_picker.dart';
import 'toggle_row.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
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
    ref
        .read(assetListFilterProvider.notifier)
        .applyFilters(
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
              FilterHandle(borderColor: borderColor),
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
                    FilterSheetHeader(onReset: _reset),
                    const SizedBox(height: AppSpacing.lg),
                    const FilterSectionLabel('Sort by'),
                    const SizedBox(height: AppSpacing.sm),
                    SortFieldPicker(
                      selected: _sortBy,
                      onChanged: (f) => setState(() => _sortBy = f),
                      chipBg: chipBg,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const FilterSectionLabel('Order'),
                    const SizedBox(height: AppSpacing.sm),
                    ToggleRow<AssetSortDirection>(
                      values: AssetSortDirection.values,
                      selected: _sortDirection,
                      label: (v) => v == AssetSortDirection.asc
                          ? 'Ascending'
                          : 'Descending',
                      icon: (v) => v == AssetSortDirection.asc
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      onChanged: (v) => setState(() => _sortDirection = v),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const FilterSectionLabel('Movement'),
                    const SizedBox(height: AppSpacing.sm),
                    ToggleRow<AssetChangeFilter>(
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
                        const FilterSectionLabel('Price Range (USD)'),
                        Switch(
                          value: _hasPriceFilter,
                          activeColor: AppColors.primary,
                          onChanged: (v) =>
                              setState(() => _hasPriceFilter = v),
                        ),
                      ],
                    ),
                    if (_hasPriceFilter) ...[
                      const SizedBox(height: AppSpacing.sm),
                      PriceRangeSlider(
                        range: _priceRange,
                        max: _sliderMax,
                        chipBg: chipBg,
                        onChanged: (r) => setState(() => _priceRange = r),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    ApplyButton(onPressed: _apply),
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
