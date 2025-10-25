import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../core/models/paged_list.dart';
import '../data/asset_model.dart';
import '../data/asset_service.dart';

final assetServiceProvider = Provider((ref) => AssetService());

final autoRefreshProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});

final assetListProvider = FutureProvider.family<PagedList<AssetModel>, int>((
  ref,
  page,
) async {
  ref.watch(autoRefreshProvider);

  final service = ref.watch(assetServiceProvider);
  return service.fetchAssets(PagedListFilter());
});

final assetRefreshProvider = StateProvider<int>((ref) => 0);

final refreshableAssetListProvider =
    FutureProvider.family<PagedList<AssetModel>, int>((ref, page) async {
      ref.watch(autoRefreshProvider);
      ref.watch(assetRefreshProvider);

      final service = ref.watch(assetServiceProvider);
      return service.fetchAssets(PagedListFilter());
    });
