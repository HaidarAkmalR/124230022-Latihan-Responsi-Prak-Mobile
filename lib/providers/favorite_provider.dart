
import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class FavoriteProvider with ChangeNotifier {
  final HiveService _hive = HiveService();
  List<int> _favorites = [];

  List<int> get favorites => _favorites;

  FavoriteProvider() {
    _load();
  }

  void _load() {
    _favorites = _hive.getFavorites();
    notifyListeners();
  }

  bool isFavorite(int id) => _favorites.contains(id);

  Future<void> addFavorite(int id) async {
    if (!_favorites.contains(id)) {
      _favorites.add(id);
      await _hive.saveFavorites(_favorites);
      notifyListeners();
    }
  }

  Future<void> removeFavorite(int id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
      await _hive.saveFavorites(_favorites);
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int id) async {
    if (isFavorite(id)) {
      await removeFavorite(id);
    } else {
      await addFavorite(id);
    }
  }
}
