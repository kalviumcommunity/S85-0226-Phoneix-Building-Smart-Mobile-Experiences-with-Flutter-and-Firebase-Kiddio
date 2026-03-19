import 'package:flutter/material.dart';

class ResponsiveDesignScreen extends StatelessWidget {
  const ResponsiveDesignScreen({super.key});

  static const routeName = '/responsive-design';

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final screenHeight = media.size.height;
    final isPortrait = media.orientation == Orientation.portrait;

    final horizontalPadding = screenWidth * 0.05;
    final titleSize = screenWidth < 600 ? 20.0 : 28.0;
    final subtitleSize = screenWidth < 600 ? 13.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Design Demo'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobileLayout = constraints.maxWidth < 700;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroBanner(
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  orientation: media.orientation.name,
                  mode: isMobileLayout ? 'Mobile Layout' : 'Tablet Layout',
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: isMobileLayout
                      ? _MobileDashboard(
                          cardHeight: isPortrait ? screenHeight * 0.14 : screenHeight * 0.24,
                        )
                      : _TabletDashboard(
                          cardHeight: isPortrait ? screenHeight * 0.16 : screenHeight * 0.22,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.titleSize,
    required this.subtitleSize,
    required this.screenWidth,
    required this.screenHeight,
    required this.orientation,
    required this.mode,
  });

  final double titleSize;
  final double subtitleSize;
  final double screenWidth;
  final double screenHeight;
  final String orientation;
  final String mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MediaQuery + LayoutBuilder',
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Mode: $mode | Orientation: $orientation',
            style: TextStyle(color: Colors.white, fontSize: subtitleSize),
          ),
          const SizedBox(height: 6),
          Text(
            'Screen: ${screenWidth.toStringAsFixed(0)} x ${screenHeight.toStringAsFixed(0)}',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.95)),
          ),
        ],
      ),
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  const _MobileDashboard({required this.cardHeight});

  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _StatCard(
          title: 'Daily Usage',
          value: '2h 18m',
          icon: Icons.timer_outlined,
          color: const Color(0xFFE0F2FE),
          cardHeight: cardHeight,
        ),
        _StatCard(
          title: 'Tasks Completed',
          value: '12',
          icon: Icons.task_alt_outlined,
          color: const Color(0xFFECFCCB),
          cardHeight: cardHeight,
        ),
        _StatCard(
          title: 'Focus Score',
          value: '87%',
          icon: Icons.auto_graph_outlined,
          color: const Color(0xFFFFEDD5),
          cardHeight: cardHeight,
        ),
      ],
    );
  }
}

class _TabletDashboard extends StatelessWidget {
  const _TabletDashboard({required this.cardHeight});

  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFE0F2FE),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tablet Sidebar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text('This panel appears only on wide screens.'),
                SizedBox(height: 8),
                Text('Use this section for filters, quick actions, or profile summary.'),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.8,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _StatCard(
                title: 'Daily Usage',
                value: '2h 18m',
                icon: Icons.timer_outlined,
                color: const Color(0xFFECFCCB),
                cardHeight: cardHeight,
              ),
              _StatCard(
                title: 'Tasks Completed',
                value: '12',
                icon: Icons.task_alt_outlined,
                color: const Color(0xFFFFEDD5),
                cardHeight: cardHeight,
              ),
              _StatCard(
                title: 'Focus Score',
                value: '87%',
                icon: Icons.auto_graph_outlined,
                color: const Color(0xFFEDE9FE),
                cardHeight: cardHeight,
              ),
              _StatCard(
                title: 'Hydration',
                value: '6 cups',
                icon: Icons.water_drop_outlined,
                color: const Color(0xFFDCFCE7),
                cardHeight: cardHeight,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.cardHeight,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
