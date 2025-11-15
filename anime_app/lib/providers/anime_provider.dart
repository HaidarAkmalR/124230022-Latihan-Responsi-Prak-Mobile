
import 'package:flutter/material.dart';
import '../models/anime_model.dart';
import '../services/api_service.dart';

class AnimeProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  List<Anime> _animes = [];
  bool _loading = false;
  String? _error;

  List<Anime> get animes => _animes;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadTopAnime() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _api.fetchTopAnime();
      _animes = res;
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<Anime> fetchDetail(int malId) => _api.fetchAnimeDetail(malId);
}
