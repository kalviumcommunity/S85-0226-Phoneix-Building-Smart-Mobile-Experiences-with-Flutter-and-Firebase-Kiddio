import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_page.dart';
import 'screens/widget_tree_demo.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  void _openOwnProfile(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(userId: user.uid),
      ),
    );
  }

  void _openOtherProfileDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('View another user profile'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Other user UID',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final otherUid = controller.text.trim();
                Navigator.pop(context);
                if (otherUid.isEmpty) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userId: otherUid),
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Tasks + Secure Profile'),
        actions: [
          IconButton(
            tooltip: 'Widget Tree Demo',
            icon: const Icon(Icons.account_tree),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WidgetTreeDemo(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'My Secure Profile',
            icon: const Icon(Icons.person),
            onPressed: () => _openOwnProfile(context),
          ),
          IconButton(
            tooltip: 'Test access to another user',
            icon: const Icon(Icons.lock),
            onPressed: () => _openOtherProfileDialog(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
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
        },
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
            return const Center(child: Text('No tasks found'));
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final data = task.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(data['title'] ?? 'No title'),
                  subtitle: Text(data['description'] ?? ''),
                  trailing: Checkbox(
                    value: data['status'] == 'completed',
                    onChanged: (bool? newValue) async {
                      if (newValue == null) return;
                      await FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(task.id)
                          .update({
                        'status': newValue ? 'completed' : 'pending',
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
