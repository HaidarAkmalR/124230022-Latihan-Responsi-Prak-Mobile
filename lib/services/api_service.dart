
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime_model.dart';

class ApiService {
  static const String base = 'https://api.jikan.moe/v4';

  Future<List<Anime>> fetchTopAnime() async {
    final url = Uri.parse('$base/top/anime');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final List data = body['data'] ?? [];
      return data.map((e) => Anime.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load top anime');
    }
  }

  Future<Anime> fetchAnimeDetail(int malId) async {
    final url = Uri.parse('$base/anime/$malId/full');
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      final data = body['data'];
      return Anime.fromJson(data);
    } else {
      throw Exception('Failed to load anime detail');
    }
  }
}
