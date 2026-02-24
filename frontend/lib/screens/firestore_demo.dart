import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreDemo extends StatefulWidget {
  const FirestoreDemo({Key? key}) : super(key: key);

  @override
  State<FirestoreDemo> createState() => _FirestoreDemoState();
}

class _FirestoreDemoState extends State<FirestoreDemo> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> _addTestItem() async {
    await _db.collection('tasks').add({
      'title': 'Task ${DateTime.now().millisecondsSinceEpoch % 1000}',
      'priority': (DateTime.now().second % 5) + 1,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    // Query: not completed, ordered by priority descending, limit 20
    final stream = _db
        .collection('tasks')
        .where('isCompleted', isEqualTo: false)
        .orderBy('priority', descending: true)
        .limit(20)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Firestore Query Demo')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTestItem,
        label: const Text('Add Test'),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No tasks match the query'));
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final d = docs[index];
              final data = d.data() as Map<String, dynamic>;
              final title = data['title'] ?? 'Untitled';
              final priority = data['priority']?.toString() ?? '-';
              final createdAt = data['createdAt'];

              return ListTile(
                title: Text(title),
                subtitle: Text('Priority: $priority' + (createdAt != null ? ' • created' : '')),
                trailing: IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: () async {
                    await d.reference.update({'isCompleted': true});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
