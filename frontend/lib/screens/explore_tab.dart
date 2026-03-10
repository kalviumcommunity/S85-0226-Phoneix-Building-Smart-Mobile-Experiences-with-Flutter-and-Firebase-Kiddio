import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/favorites_provider.dart';
import '../widgets/favorite_toggle_button.dart';

/// Explore Tab — browse items and add/remove favorites.
/// State is preserved via Provider and PageView, so switching tabs
/// does NOT reset the favorites or scroll position.
class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  static const _categories = [
    {'icon': Icons.music_note, 'label': 'Music'},
    {'icon': Icons.movie, 'label': 'Movies'},
    {'icon': Icons.book, 'label': 'Books'},
    {'icon': Icons.sports_soccer, 'label': 'Sports'},
    {'icon': Icons.restaurant, 'label': 'Food'},
    {'icon': Icons.flight, 'label': 'Travel'},
  ];

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;
    final items = List.generate(12, (i) => 'Item ${i + 1}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          // --- Category chips ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Categories',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            Colors.blue.shade50,
                        child: Icon(cat['icon'] as IconData,
                            color: Colors.blue),
                      ),
                      const SizedBox(height: 4),
                      Text(cat['label'] as String,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  );
                },
              ),
            ),
          ),

          // --- Explore items grid ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text('Popular Items',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  final isFav = favorites.contains(item);
                  return Card(
                    elevation: 2,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.explore,
                              size: 32, color: Colors.blueGrey),
                          const SizedBox(height: 8),
                          Text(item,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          FavoriteToggleButton(
                            isFavorite: isFav,
                            onToggle: () {
                              final notifier = context.read<FavoritesProvider>();
                              isFav
                                  ? notifier.removeFavorite(item)
                                  : notifier.addFavorite(item);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: items.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 3.2,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
