import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
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
        data: (paged) => Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: paged.data.length,
                separatorBuilder: (_, __) =>
                    Divider(color: AppColors.borderLight.withOpacity(0.3)),
                itemBuilder: (context, index) {
                  final asset = paged.data[index];
                  final isPositive = asset.percentChange1h >= 0;

                  return ListTile(
                    title: Text(
                      asset.name,
                      style: const TextStyle(
                        fontWeight: AppTypography.fontWeightMedium,
                        fontSize: AppTypography.textBase,
                      ),
                    ),
                    subtitle: Text(
                      asset.symbol,
                      style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.8),
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${asset.priceUsd.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: AppTypography.fontWeightSemiBold,
                          ),
                        ),
                        Text(
                          '${asset.percentChange1h.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: isPositive
                                ? AppColors.primaryLight
                                : AppColors.error,
                            fontWeight: AppTypography.fontWeightMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: paged.hasPreviousPage ? previousPage : null,
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  ),
                  Text(
                    'Page ${paged.pageNumber} / ${paged.totalPages}',
                    style: const TextStyle(
                      fontWeight: AppTypography.fontWeightMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: paged.hasNextPage
                        ? () => nextPage(paged.totalPages)
                        : null,
                    icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
