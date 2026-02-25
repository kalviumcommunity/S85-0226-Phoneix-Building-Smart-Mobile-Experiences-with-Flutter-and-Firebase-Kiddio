import 'package:flutter/material.dart';

/// Simple demo to visualize a widget tree and show Flutter's reactive UI model.
class WidgetTreeDemo extends StatefulWidget {
  const WidgetTreeDemo({super.key});

  @override
  State<WidgetTreeDemo> createState() => _WidgetTreeDemoState();
}

class _WidgetTreeDemoState extends State<WidgetTreeDemo> {
  int _count = 0;
  bool _showDetails = true;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _toggleDetails(bool value) {
    setState(() {
      _showDetails = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Tree & Reactive UI'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Profile Card Demo',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        child: Icon(Icons.person, size: 32),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Flutter Learner',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Button pressed: $_count times',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: const Text('Show extra details'),
                        value: _showDetails,
                        onChanged: _toggleDetails,
                      ),
                      if (_showDetails) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'This extra section only appears when the switch is ON.\n'
                          'It is part of the same widget tree and is rebuilt reactively.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _increment,
                        child: const Text('Increment counter'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

