import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../asset_list/data/asset_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/favorite_service.dart';

final favoriteServiceProvider = Provider((ref) => FavoriteService());

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<AssetModel>>(
        FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<List<AssetModel>> {
  @override
  Future<List<AssetModel>> build() async {
    final user = ref.watch(currentUserProvider);
    if (user == null) return [];
    return ref.read(favoriteServiceProvider).getFavorites(user.id);
  }

  Future<void> toggle(int assetId) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    final service = ref.read(favoriteServiceProvider);
    final isFavorite = await service.toggleFavorite(user.id, assetId);

    final current = state.value ?? [];

    if (isFavorite) {
      state = AsyncData([...current]);
    } else {
      state = AsyncData(current.where((a) => a.id != assetId).toList());
    }

    ref.invalidateSelf();
  }

  bool isFavorite(int assetId) {
    return state.value?.any((a) => a.id == assetId) ?? false;
  }
}

extension FavoritesProviderX on AsyncValue<List<AssetModel>> {
  bool containsId(int assetId) =>
      value?.any((a) => a.id == assetId) ?? false;
}
