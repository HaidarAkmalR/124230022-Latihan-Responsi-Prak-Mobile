
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anime_provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/anime_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/bottom_navbar.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AnimeProvider? _animeProv;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _animeProv = Provider.of<AnimeProvider>(context, listen: false);
      _animeProv!.loadTopAnime();
    });
  }

  Future<void> _refresh() async => await _animeProv!.loadTopAnime();

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        
        break;

      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FavoritesPage()),
        ).then((_) {
          
          if (mounted) {
            setState(() => _currentIndex = 0);
          }
        });
        break;

      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        ).then((_) {
          
          if (mounted) {
            setState(() => _currentIndex = 0);
          }
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final animeProv = Provider.of<AnimeProvider>(context);
    final favProv = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 32, 16, 10),
              child: Text(
                "Top Anime",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: Builder(builder: (_) {
                if (animeProv.loading) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: 6,
                    itemBuilder: (_, __) => const ShimmerLoading(height: 260),
                  );
                }

                if (animeProv.error != null) {
                  return Center(child: Text('Error: ${animeProv.error}'));
                }

                final list = animeProv.animes;

                return GridView.builder(
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
                      isFav: favProv.isFavorite(a.malId),
                      onFavToggle: () => favProv.toggleFavorite(a.malId),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailPage(anime: a)),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
