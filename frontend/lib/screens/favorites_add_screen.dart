import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/favorites_provider.dart';

/// Screen A: lets the user add items to the global favorites list
/// without passing any props between screens.
class FavoritesAddScreen extends StatelessWidget {
  const FavoritesAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;
    final items = List.generate(10, (i) => 'Item ${i + 1}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen A – Add Favorites'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final isFav = favorites.contains(item);

          return ListTile(
            title: Text(item),
            trailing: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : null,
              ),
              onPressed: () {
                final notifier = context.read<FavoritesProvider>();
                if (isFav) {
                  notifier.removeFavorite(item);
                } else {
                  notifier.addFavorite(item);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

