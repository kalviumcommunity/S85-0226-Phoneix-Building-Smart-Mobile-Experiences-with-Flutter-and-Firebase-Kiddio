import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'live_items_viewer_screen.dart';

/// Home Tab — displays user's Firestore tasks with add & toggle support.
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<void> _addTask() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('tasks').add({
      'userId': user.uid,
      'title': 'New Task',
      'description': 'Describe your task',
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home — ${user?.email ?? "Guest"}'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Live Items Viewer',
            onPressed: () {
              Navigator.pushNamed(context, LiveItemsViewerScreen.routeName);
            },
            icon: const Icon(Icons.data_object),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_fab',
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No tasks yet. Tap + to add one!'),
            );
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final data = task.data() as Map<String, dynamic>;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  title: Text(data['title'] ?? 'No title'),
                  subtitle: Text(data['description'] ?? ''),
                  trailing: Checkbox(
                    value: data['status'] == 'completed',
                    onChanged: (bool? val) async {
                      if (val == null) return;
                      await FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(task.id)
                          .update({
                        'status': val ? 'completed' : 'pending',
                        'updatedAt': FieldValue.serverTimestamp(),
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
