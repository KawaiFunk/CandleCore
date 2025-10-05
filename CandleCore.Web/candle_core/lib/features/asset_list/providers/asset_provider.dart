import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/paged_list.dart';
import '../data/asset_model.dart';
import '../data/asset_service.dart';

final assetServiceProvider = Provider((ref) => AssetService());

final assetListProvider = FutureProvider.family<PagedList<AssetModel>, int>((ref, page) async {
  final service = ref.watch(assetServiceProvider);
  return service.fetchAssets(PagedListFilter());
});
