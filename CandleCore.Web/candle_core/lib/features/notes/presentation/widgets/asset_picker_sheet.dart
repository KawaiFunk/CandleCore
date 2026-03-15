import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/tokens.dart';
import '../../../asset_list/data/asset_model.dart';
import '../../../asset_list/providers/asset_provider.dart';

class AssetPickerSheet extends ConsumerStatefulWidget {
  final void Function(AssetModel asset) onSelected;

  const AssetPickerSheet({super.key, required this.onSelected});

  @override
  ConsumerState<AssetPickerSheet> createState() => _AssetPickerSheetState();
}

class _AssetPickerSheetState extends ConsumerState<AssetPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filter = AssetListFilter(search: _query, pageSize: 20);
    final assetsAsync = ref.watch(pagedAssetListProvider(filter));

    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.lg,
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
            'Select Asset',
            style: TextStyle(
              fontSize: AppTypography.textLg,
              fontWeight: AppTypography.fontWeightSemiBold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v),
            style: const TextStyle(fontSize: AppTypography.textBase),
            decoration: InputDecoration(
              hintText: 'Search coins...',
              hintStyle: const TextStyle(color: AppColors.textSecondary),
              prefixIcon: const Icon(Icons.search,
                  color: AppColors.textSecondary, size: 20),
              filled: true,
              fillColor: isDark
                  ? AppColors.inputBackgroundDark
                  : AppColors.inputBackgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.lg),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: 300,
            child: assetsAsync.when(
              data: (paged) => ListView.builder(
                itemCount: paged.data.length,
                itemBuilder: (context, index) {
                  final asset = paged.data[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                      child: Center(
                        child: Text(
                          asset.symbol.length > 2
                              ? asset.symbol.substring(0, 2)
                              : asset.symbol,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: AppTypography.textXs,
                            fontWeight: AppTypography.fontWeightBold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      asset.name,
                      style: const TextStyle(
                        fontSize: AppTypography.textSm,
                        fontWeight: AppTypography.fontWeightSemiBold,
                      ),
                    ),
                    subtitle: Text(
                      asset.symbol,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppTypography.textXs,
                      ),
                    ),
                    onTap: () {
                      widget.onSelected(asset);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
              error: (_, __) => const Center(
                child: Text(
                  'Failed to load assets',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
