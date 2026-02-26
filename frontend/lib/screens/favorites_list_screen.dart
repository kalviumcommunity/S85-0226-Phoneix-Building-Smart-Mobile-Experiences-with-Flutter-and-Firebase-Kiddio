import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/favorites_provider.dart';

/// Screen B: shows the global favorites list and lets you remove items.
/// Changes here will reflect back on Screen A automatically.
class FavoritesListScreen extends StatelessWidget {
  const FavoritesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen B – Favorites List'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('No favorites yet. Add some from Screen A.'),
            )
          : ListView.separated(
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = favorites[index];
                return ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      context.read<FavoritesProvider>().removeFavorite(item);
                    },
                  ),
                );
              },
            ),
    );
  }
}

