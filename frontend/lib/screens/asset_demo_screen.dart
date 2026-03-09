import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Demonstrates loading and displaying local images, custom icon assets,
/// and Flutter's built-in Material & Cupertino icons.
class AssetDemoScreen extends StatelessWidget {
  const AssetDemoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assets Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section 1: Logo image ──────────────────────────────
            const _SectionTitle('Local Image – Logo'),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Section 2: Banner image ────────────────────────────
            const _SectionTitle('Local Image – Banner'),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/banner.jpg',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // ── Section 3: Background image inside Container ───────
            const _SectionTitle('Image as Background (AssetImage)'),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Center(
                child: Text(
                  'Welcome to Flutter!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Section 4: Custom icon assets ──────────────────────
            const _SectionTitle('Custom Icon Assets'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _iconTile('assets/icons/star.png', 'Star'),
                const SizedBox(width: 32),
                _iconTile('assets/icons/profile.png', 'Profile'),
              ],
            ),
            const SizedBox(height: 24),

            // ── Section 5: Built-in Material Icons ─────────────────
            const _SectionTitle('Built-in Material Icons'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 36),
                SizedBox(width: 12),
                Icon(Icons.flutter_dash, color: Colors.blue, size: 36),
                SizedBox(width: 12),
                Icon(Icons.android, color: Colors.green, size: 36),
                SizedBox(width: 12),
                Icon(Icons.apple, color: Colors.grey, size: 36),
                SizedBox(width: 12),
                Icon(Icons.favorite, color: Colors.red, size: 36),
              ],
            ),
            const SizedBox(height: 24),

            // ── Section 6: Cupertino (iOS) Icons ───────────────────
            const _SectionTitle('Cupertino (iOS) Icons'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 32),
                SizedBox(width: 12),
                Icon(CupertinoIcons.bell_fill, color: Colors.orange, size: 32),
                SizedBox(width: 12),
                Icon(CupertinoIcons.person_fill, color: Colors.purple, size: 32),
                SizedBox(width: 12),
                Icon(CupertinoIcons.settings, color: Colors.blueGrey, size: 32),
              ],
            ),
            const SizedBox(height: 24),

            // ── Section 7: Combined layout ─────────────────────────
            const _SectionTitle('Combined Images & Icons'),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png', width: 80),
                    const SizedBox(height: 12),
                    const Text(
                      'Powered by Flutter',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.flutter_dash, color: Colors.blue, size: 36),
                        SizedBox(width: 10),
                        Icon(Icons.android, color: Colors.green, size: 36),
                        SizedBox(width: 10),
                        Icon(Icons.apple, color: Colors.grey, size: 36),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Helper: custom icon asset tile with a label.
  static Widget _iconTile(String assetPath, String label) {
    return Column(
      children: [
        Image.asset(assetPath, width: 64, height: 64),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

/// Reusable section heading widget.
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
