import 'package:flutter/material.dart';

/// Reusable favorite toggle with a small "pop" animation.
///
/// This widget is intentionally reusable and UI-only:
/// - The favorite state is controlled by [isFavorite]
/// - Toggling is delegated to [onToggle] (Provider, Riverpod, setState, etc.)
class FavoriteToggleButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onToggle;
  final double size;

  const FavoriteToggleButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.size = 22,
  });

  @override
  State<FavoriteToggleButton> createState() => _FavoriteToggleButtonState();
}

class _FavoriteToggleButtonState extends State<FavoriteToggleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isFavorite ? Colors.red : Colors.grey;
    final icon = widget.isFavorite ? Icons.favorite : Icons.favorite_border;

    return IconButton(
      tooltip: widget.isFavorite ? 'Unfavorite' : 'Favorite',
      onPressed: () {
        setState(() => _pressed = true);
        widget.onToggle();
        Future<void>.delayed(const Duration(milliseconds: 140), () {
          if (!mounted) return;
          setState(() => _pressed = false);
        });
      },
      icon: AnimatedScale(
        scale: _pressed ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Icon(icon, color: color, size: widget.size),
      ),
    );
  }
}

