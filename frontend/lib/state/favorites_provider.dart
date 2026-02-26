import 'package:flutter/foundation.dart';

/// Simple global state for "Favorites Sync" demo.
class FavoritesProvider extends ChangeNotifier {
  final List<String> _favorites = [];

  List<String> get favorites => List.unmodifiable(_favorites);

  bool isFavorite(String item) => _favorites.contains(item);

  void addFavorite(String item) {
    if (_favorites.contains(item)) return;
    _favorites.add(item);
    notifyListeners();
  }

  void removeFavorite(String item) {
    _favorites.remove(item);
    notifyListeners();
  }
}

