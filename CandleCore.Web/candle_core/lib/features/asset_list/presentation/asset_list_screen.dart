import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../../../shared/widgets/asset/asset_list_item/asset_list_item.dart';
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
    final asyncPage = ref.watch(assetListProvider(currentPage));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
      ),
      body: asyncPage.when(
        data: (paged) => Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: paged.pageSize,
                  itemBuilder: (context, index) {
                    final asset = paged.data[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: AssetListItem(asset: asset)
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
