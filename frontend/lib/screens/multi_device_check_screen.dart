import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MultiDeviceCheckScreen extends StatelessWidget {
  const MultiDeviceCheckScreen({super.key});

  static const routeName = '/multi-device-check';

  String _platformLabel() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'Android';
      case TargetPlatform.iOS:
        return 'iOS';
      case TargetPlatform.macOS:
        return 'macOS';
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
    }
  }

  String _sizeClass(double width) {
    if (width < 600) return 'Compact phone';
    if (width < 840) return 'Medium tablet';
    return 'Expanded desktop/tablet';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final orientation = mediaQuery.orientation;
    final brightness = Theme.of(context).brightness;

    final infoTiles = <Widget>[
      _InfoTile(
        icon: Icons.devices,
        label: 'Platform',
        value: _platformLabel(),
      ),
      _InfoTile(
        icon: Icons.straighten,
        label: 'Logical size',
        value: '${width.toStringAsFixed(0)} x ${height.toStringAsFixed(0)}',
      ),
      _InfoTile(
        icon: Icons.screen_rotation,
        label: 'Orientation',
        value: orientation.name,
      ),
      _InfoTile(
        icon: Icons.dashboard_customize,
        label: 'Size class',
        value: _sizeClass(width),
      ),
      _InfoTile(
        icon: Icons.palette_outlined,
        label: 'Theme mode now',
        value: brightness == Brightness.dark ? 'Dark' : 'Light',
      ),
      _InfoTile(
        icon: Icons.speed,
        label: 'Frame source',
        value: kReleaseMode ? 'Release' : 'Debug/Profile',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Device Compatibility Check'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 850;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Use this page during your 3.48 video demo.',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Show this screen on two devices to prove responsive layout and runtime consistency.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: wide ? 3 : 2,
                  childAspectRatio: wide ? 2.8 : 2.4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: infoTiles,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Validation Checklist',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        const _CheckItem('Navigation across tabs works'),
                        const _CheckItem('Task list loads and interactions work'),
                        const _CheckItem('Theme is applied correctly'),
                        const _CheckItem('No UI overflow on this device'),
                        const _CheckItem('No crashes in console logs'),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Location test screen is not available in this branch yet.',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.location_on_outlined),
                              label: const Text('Test Location Permission'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.home_outlined),
                              label: const Text('Back to Home'),
                            ),
                          ],
                        ),
                      ],
                    ),
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

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  const _CheckItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
