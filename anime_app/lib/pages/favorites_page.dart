
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/anime_provider.dart';
import '../widgets/anime_card.dart';
import 'detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favProv = Provider.of<FavoriteProvider>(context);
    final animeProv = Provider.of<AnimeProvider>(context, listen: false);

    final favIds = favProv.favorites;
    final list = animeProv.animes.where((a) => favIds.contains(a.malId)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true); 
          },
        ),
      ),
      body: list.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                childAspectRatio: 0.62,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: list.length,
              itemBuilder: (ctx, idx) {
                final a = list[idx];
                return AnimeCard(
                  anime: a,
                  isFav: true,
                  onFavToggle: () => favProv.toggleFavorite(a.malId),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(anime: a)),
                  ),
                );
              },
            ),
    );
  }
}
