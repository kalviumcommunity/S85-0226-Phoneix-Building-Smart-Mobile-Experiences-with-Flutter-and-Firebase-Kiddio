import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum _TaskFilter { all, pending, completed }

/// Home Tab — displays user's Firestore tasks with add & toggle support.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  _TaskFilter _filter = _TaskFilter.all;

  @override
  void initState() {
    super.initState();
  }

  Query<Map<String, dynamic>> _queryForUserTasks(String userId) {
    final base = FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId);

    switch (_filter) {
      case _TaskFilter.all:
        return base
            .orderBy('updatedAt', descending: true)
            .orderBy('createdAt', descending: true);
      case _TaskFilter.pending:
        return base
            .where('status', isEqualTo: 'pending')
            .orderBy('updatedAt', descending: true)
            .orderBy('createdAt', descending: true);
      case _TaskFilter.completed:
        return base
            .where('status', isEqualTo: 'completed')
            .orderBy('updatedAt', descending: true)
            .orderBy('createdAt', descending: true);
    }
  }

  Future<void> _toggleTaskStatus({
    required String taskId,
    required bool completed,
  }) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
      'status': completed ? 'completed' : 'pending',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _showAddTaskSheet({required String userId}) async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    if (!mounted) return;
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 16 + bottomInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add task',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: titleController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g. Pick up meds',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Any details you want to remember',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  final title = titleController.text.trim();
                  final description = descriptionController.text.trim();
                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a title.')),
                    );
                    return;
                  }

                  await FirebaseFirestore.instance.collection('tasks').add({
                    'userId': userId,
                    'title': title,
                    'description': description,
                    'status': 'pending',
                    'createdAt': FieldValue.serverTimestamp(),
                    'updatedAt': FieldValue.serverTimestamp(),
                  });

                  if (context.mounted) Navigator.pop(context, true);
                },
                icon: const Icon(Icons.add),
                label: const Text('Create task'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );

    titleController.dispose();
    descriptionController.dispose();

    if (!mounted) return;
    if (created == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task created.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in to see your tasks.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text('Go to login'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks — ${user.email ?? "Account"}'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'home_fab',
        onPressed: () => _showAddTaskSheet(userId: user.uid),
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SegmentedButton<_TaskFilter>(
                segments: const [
                  ButtonSegment(
                    value: _TaskFilter.all,
                    label: Text('All'),
                    icon: Icon(Icons.list),
                  ),
                  ButtonSegment(
                    value: _TaskFilter.pending,
                    label: Text('Pending'),
                    icon: Icon(Icons.radio_button_unchecked),
                  ),
                  ButtonSegment(
                    value: _TaskFilter.completed,
                    label: Text('Completed'),
                    icon: Icon(Icons.check_circle_outline),
                  ),
                ],
                selected: {_filter},
                onSelectionChanged: (selection) {
                  setState(() => _filter = selection.first);
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _queryForUserTasks(user.uid).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tasks = snapshot.data?.docs ?? [];
                  if (tasks.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _filter == _TaskFilter.completed
                                  ? 'No completed tasks yet.'
                                  : _filter == _TaskFilter.pending
                                      ? 'No pending tasks — nice work.'
                                      : 'No tasks yet.',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap “Add task” to create your first one.',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: () => _showAddTaskSheet(userId: user.uid),
                              icon: const Icon(Icons.add),
                              label: const Text('Add task'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final data = task.data();
                      final title = (data['title'] as String?)?.trim();
                      final description = (data['description'] as String?)?.trim();
                      final isCompleted = data['status'] == 'completed';

                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          leading: Icon(
                            isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: isCompleted
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                          ),
                          title: Text(title?.isNotEmpty == true ? title! : 'Untitled'),
                          subtitle: (description?.isNotEmpty == true)
                              ? Text(description!)
                              : null,
                          trailing: Switch(
                            value: isCompleted,
                            onChanged: (val) => _toggleTaskStatus(
                              taskId: task.id,
                              completed: val,
                            ),
                          ),
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
