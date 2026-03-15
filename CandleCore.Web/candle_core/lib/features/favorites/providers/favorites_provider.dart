import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Set<String>>(FavoritesNotifier.new);

class FavoritesNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => {};

  void toggle(String symbol) {
    if (state.contains(symbol)) {
      state = {...state}..remove(symbol);
    } else {
      state = {...state, symbol};
    }
  }

  bool isFavorite(String symbol) => state.contains(symbol);
}
