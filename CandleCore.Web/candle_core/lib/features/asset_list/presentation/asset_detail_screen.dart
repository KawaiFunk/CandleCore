import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../features/favorites/providers/favorites_provider.dart';
import '../../../features/notes/presentation/widgets/quick_note_sheet.dart';
import '../../../features/notes/providers/notes_provider.dart';
import '../data/asset_model.dart';
import '../providers/asset_provider.dart';
import 'widgets/change_section.dart';
import 'widgets/detail_app_bar.dart';
import 'widgets/price_header.dart';
import 'widgets/stats_grid.dart';

class AssetDetailScreen extends ConsumerWidget {
  final int assetId;

  const AssetDetailScreen({super.key, required this.assetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAsset = ref.watch(assetDetailProvider(assetId));

    return asyncAsset.when(
      data: (asset) => _DetailView(asset: asset),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: AppSpacing.md),
                Text(
                  err is ApiException ? err.message : 'Failed to load asset.',
                  style: const TextStyle(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () => ref.invalidate(assetDetailProvider(assetId)),
                  child: const Text('Retry',
                      style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailView extends ConsumerStatefulWidget {
  final DetailedAssetModel asset;

  const _DetailView({required this.asset});

  @override
  ConsumerState<_DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends ConsumerState<_DetailView> {
  void _showAddNoteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuickNoteSheet(
        asset: widget.asset,
        onSave: (title, body) async {
          await ref.read(notesProvider.notifier).create(
                title: title,
                body: body,
                assetId: widget.asset.id,
              );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFavorite = ref.watch(
      favoritesProvider.select((s) => s.containsId(widget.asset.id)),
    );
    final isPositive = widget.asset.percentChange1h >= 0;
    final changeColor = isPositive ? AppColors.primary : AppColors.error;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DetailAppBar(
            asset: widget.asset,
            isFavorite: isFavorite,
            changeColor: changeColor,
            isPositive: isPositive,
            isDark: isDark,
            onFavoriteTap: () =>
                ref.read(favoritesProvider.notifier).toggle(widget.asset.id),
            onAddNoteTap: _showAddNoteSheet,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PriceHeader(asset: widget.asset, changeColor: changeColor, isPositive: isPositive),
                  const SizedBox(height: AppSpacing.lg),
                  StatsGrid(asset: widget.asset, isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),
                  ChangeSection(asset: widget.asset, isDark: isDark),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
