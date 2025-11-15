
class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final double score;
  final String synopsis;
  final String status;
  final String trailerUrl;

  Anime({
    required this.malId,
    required this.title,
    required this.imageUrl,
    required this.score,
    required this.synopsis,
    required this.status,
    required this.trailerUrl,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['images']?['jpg']?['image_url'] ?? '',
      score: (json['score'] is num) ? (json['score'] as num).toDouble() : 0.0,
      synopsis: json['synopsis'] ?? '',
      status: json['status'] ?? '',
      trailerUrl: json['trailer']?['embed_url'] ?? '',
    );
  }
}
