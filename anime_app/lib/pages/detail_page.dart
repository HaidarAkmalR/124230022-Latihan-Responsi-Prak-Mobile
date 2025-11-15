
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/anime_model.dart';
import '../providers/favorite_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final Anime anime;
  const DetailPage({super.key, required this.anime});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    final fav = Provider.of<FavoriteProvider>(context, listen: false);
    _isFav = fav.isFavorite(widget.anime.malId);
  }

  Future<void> _openTrailer(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  
  String _convertEmbedToWatch(String embedUrl) {
    if (embedUrl.isEmpty) return "";

    
    final videoId = embedUrl.split('/').last.split('?').first;

    return "https://www.youtube.com/watch?v=$videoId";
  }

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoriteProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(widget.anime.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: Image.network(
                widget.anime.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    widget.anime.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  IconButton(
                    icon: Icon(
                      _isFav ? Icons.favorite : Icons.favorite_border,
                      color: _isFav ? Colors.red : null,
                    ),
                    onPressed: () async {
                      await favProv.toggleFavorite(widget.anime.malId);
                      setState(() {
                        _isFav = !_isFav;
                      });
                    },
                  )
                ],
              ),
            ),
            ListTile(
                title: const Text('Score'),
                trailing: Text(widget.anime.score.toString())),
            ListTile(
                title: const Text('Status'),
                trailing: Text(widget.anime.status)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(widget.anime.synopsis.isEmpty
                  ? 'No synopsis available.'
                  : widget.anime.synopsis),
            ),

          
            if (widget.anime.trailerUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ElevatedButton.icon(
                  onPressed: () {
                    final watchUrl =
                        _convertEmbedToWatch(widget.anime.trailerUrl);
                    _openTrailer(watchUrl);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Watch Trailer'),
                ),
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
