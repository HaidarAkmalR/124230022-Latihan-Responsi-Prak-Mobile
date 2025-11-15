import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/anime_model.dart';
import '../providers/favorite_provider.dart';

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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
              trailing: Text(widget.anime.score.toString()),
            ),
            ListTile(
              title: const Text('Status'),
              trailing: Text(widget.anime.status),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                widget.anime.synopsis.isEmpty
                    ? 'No synopsis available.'
                    : widget.anime.synopsis,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
