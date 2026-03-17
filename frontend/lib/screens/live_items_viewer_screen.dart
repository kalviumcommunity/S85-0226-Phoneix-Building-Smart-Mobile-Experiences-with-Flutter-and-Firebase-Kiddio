import 'dart:developer';

import 'package:flutter/material.dart';

enum LiveItemsScenario { success, empty, error }

class LiveItemsViewerScreen extends StatefulWidget {
  const LiveItemsViewerScreen({super.key});

  static const routeName = '/live-items-viewer';

  @override
  State<LiveItemsViewerScreen> createState() => _LiveItemsViewerScreenState();
}

class _LiveItemsViewerScreenState extends State<LiveItemsViewerScreen> {
  LiveItemsScenario _scenario = LiveItemsScenario.success;
  int _requestKey = 0;

  Future<List<String>> _fetchItems() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    switch (_scenario) {
      case LiveItemsScenario.success:
        return List<String>.generate(6, (index) => 'Live Item ${index + 1}');
      case LiveItemsScenario.empty:
        return <String>[];
      case LiveItemsScenario.error:
        throw Exception('Data fetch failed for Live Items Viewer.');
    }
  }

  void _retry() {
    setState(() {
      _requestKey++;
    });
  }

  void _changeScenario(LiveItemsScenario nextScenario) {
    setState(() {
      _scenario = nextScenario;
      _requestKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Items Viewer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<LiveItemsScenario>(
              segments: const [
                ButtonSegment<LiveItemsScenario>(
                  value: LiveItemsScenario.success,
                  icon: Icon(Icons.check_circle_outline),
                  label: Text('Success'),
                ),
                ButtonSegment<LiveItemsScenario>(
                  value: LiveItemsScenario.empty,
                  icon: Icon(Icons.inbox_outlined),
                  label: Text('Empty'),
                ),
                ButtonSegment<LiveItemsScenario>(
                  value: LiveItemsScenario.error,
                  icon: Icon(Icons.error_outline),
                  label: Text('Error'),
                ),
              ],
              selected: <LiveItemsScenario>{_scenario},
              onSelectionChanged: (selection) {
                final nextScenario = selection.first;
                _changeScenario(nextScenario);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<String>>(
                key: ValueKey<int>(_requestKey),
                future: _fetchItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    log(
                      'Live Items Viewer error',
                      error: snapshot.error,
                      stackTrace: snapshot.stackTrace,
                    );
                    return _ErrorState(onRetry: _retry);
                  }

                  final items = snapshot.data ?? <String>[];
                  if (items.isEmpty) {
                    return _EmptyState(onRefresh: _retry);
                  }

                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.bolt)),
                        title: Text(items[index]),
                        subtitle: const Text('Fetched from async source'),
                        tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 44,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 10),
          const Text(
            'Something went wrong while loading items.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_rounded, size: 44),
          const SizedBox(height: 10),
          const Text(
            'No items found.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Try refreshing or add your first item.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
