import 'package:flutter/material.dart';

/// Demonstrates responsive layout using Rows, Columns, Containers,
/// MediaQuery, Expanded, and Flexible.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final isWide = width > 600; // tablet / desktop breakpoint

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Layout Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            _buildHeader(isWide),

            const SizedBox(height: 16),

            // ── Main Content: Row on wide, Column on narrow ────────
            isWide ? _buildWideBody(context) : _buildNarrowBody(context),

            const SizedBox(height: 16),

            // ── Feature Cards Row ──────────────────────────────────
            _buildFeatureCards(isWide),

            const SizedBox(height: 16),

            // ── Footer ─────────────────────────────────────────────
            _buildFooter(isWide),
          ],
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────────
  Widget _buildHeader(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isWide ? 40 : 24,
        horizontal: isWide ? 48 : 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kiddio App',
            style: TextStyle(
              fontSize: isWide ? 32 : 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Responsive layout built with Rows, Columns & Containers',
            style: TextStyle(
              fontSize: isWide ? 18 : 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Wide (tablet / desktop) body ────────────────────────────────
  Widget _buildWideBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left panel — takes 2/3 of width
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Main Content',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text(
                    'This panel uses Expanded with flex: 2 to take up two-thirds '
                    'of the available width on wide screens. The layout switches '
                    'to a single Column on narrow screens using MediaQuery.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Rows arrange children horizontally while Columns stack '
                    'them vertically. Containers add padding, decoration, and '
                    'constraints around their children.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Right panel — takes 1/3 of width
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                children: const [
                  Icon(Icons.info_outline, size: 48, color: Colors.deepPurple),
                  SizedBox(height: 12),
                  Text('Sidebar',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    'This sidebar uses Expanded with flex: 1 and sits inside '
                    'a Row alongside the main content.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Narrow (phone) body ─────────────────────────────────────────
  Widget _buildNarrowBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Main Content',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Text(
                  'On narrow screens MediaQuery detected a width ≤ 600px, '
                  'so the layout uses a single Column instead of a Row.',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
                SizedBox(height: 12),
                Text(
                  'Rows, Columns, and Containers are used together to '
                  'create adaptive layouts that look great on any device.',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              children: const [
                Icon(Icons.info_outline, size: 48, color: Colors.deepPurple),
                SizedBox(height: 12),
                Text('Sidebar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  'On narrow screens this sidebar stacks below the main '
                  'content in a Column instead of sitting beside it in a Row.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Feature Cards ───────────────────────────────────────────────
  Widget _buildFeatureCards(bool isWide) {
    final cards = <_FeatureInfo>[
      _FeatureInfo(Icons.view_column, 'Row', 'Horizontal layout'),
      _FeatureInfo(Icons.view_stream, 'Column', 'Vertical layout'),
      _FeatureInfo(Icons.crop_square, 'Container', 'Styling & padding'),
      _FeatureInfo(Icons.aspect_ratio, 'MediaQuery', 'Screen-aware sizing'),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 24.0 : 16.0),
      child: isWide
          ? Row(
              children: cards
                  .map((c) => Expanded(child: _featureCard(c)))
                  .toList(),
            )
          : Column(
              children: cards.map((c) => _featureCard(c)).toList(),
            ),
    );
  }

  Widget _featureCard(_FeatureInfo info) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(info.icon, size: 36, color: Colors.deepPurple),
          const SizedBox(height: 8),
          Text(info.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(info.subtitle,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
        ],
      ),
    );
  }

  // ─── Footer ──────────────────────────────────────────────────────
  Widget _buildFooter(bool isWide) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: isWide ? 48 : 20,
      ),
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© 2025 Kiddio',
            style: TextStyle(fontSize: isWide ? 14 : 12, color: Colors.black54),
          ),
          Row(
            children: const [
              Icon(Icons.phone, size: 18, color: Colors.black45),
              SizedBox(width: 8),
              Icon(Icons.email, size: 18, color: Colors.black45),
              SizedBox(width: 8),
              Icon(Icons.public, size: 18, color: Colors.black45),
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper class holding feature-card data.
class _FeatureInfo {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureInfo(this.icon, this.title, this.subtitle);
}
