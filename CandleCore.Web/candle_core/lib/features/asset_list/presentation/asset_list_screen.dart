import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/asset/asset_list_item/asset_list_item.dart';
import '../../../shared/widgets/asset/asset_stats_card/asset_stats_card.dart';
import '../providers/asset_provider.dart';

class AssetListScreen extends ConsumerStatefulWidget {
  const AssetListScreen({super.key});

  @override
  ConsumerState<AssetListScreen> createState() => _AssetListScreenState();
}

class _AssetListScreenState extends ConsumerState<AssetListScreen> {
  int currentPage = 1;

  void nextPage(int totalPages) {
    if (currentPage < totalPages) {
      setState(() => currentPage++);
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncPage = ref.watch(refreshableAssetListProvider(currentPage));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Markets'),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: asyncPage.when(
            data: (paged) {
              final stats = AssetStats.fromAssets(paged.data);
              
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: AssetStatsCard(stats: stats),
                  ),
                  
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverList.builder(
                      itemCount: paged.pageSize,
                      itemBuilder: (context, index) {
                        final asset = paged.data[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: AssetListItem(asset: asset),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(strokeWidth: 2),
                  SizedBox(height: 16),
                  Text('Loading assets...'),
                ],
              ),
            ),
            error: (err, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $err'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _manualRefresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _manualRefresh() {
    ref.read(assetRefreshProvider.notifier).state++;
  }

  Future<void> _onRefresh() async {
    _manualRefresh();
    return ref.read(refreshableAssetListProvider(currentPage).future);
  }
}
