import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;

  const HeaderWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CounterColorWidget extends StatefulWidget {
  const CounterColorWidget({Key? key}) : super(key: key);

  @override
  State<CounterColorWidget> createState() => _CounterColorWidgetState();
}

class _CounterColorWidgetState extends State<CounterColorWidget> {
  int _count = 0;
  bool _isBlue = true;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _toggleColor() {
    setState(() {
      _isBlue = !_isBlue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bg = _isBlue ? Colors.blue.shade100 : Colors.orange.shade100;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Counter: $_count', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _increment, child: const Text('Increment')),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: _toggleColor, child: const Text('Toggle Color')),
            ],
          )
        ],
      ),
    );
  }
}

class StatelessStatefulDemo extends StatelessWidget {
  const StatelessStatefulDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stateless vs Stateful')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HeaderWidget(title: 'Interactive Demo: Stateless & Stateful'),
              const SizedBox(height: 8),
              const Text('Header above is a StatelessWidget — it does not manage internal state.'),
              const SizedBox(height: 20),
              const CounterColorWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
