import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CaregiverSearch extends StatefulWidget {
  const CaregiverSearch({Key? key}) : super(key: key);

  @override
  State<CaregiverSearch> createState() => _CaregiverSearchState();
}

class _CaregiverSearchState extends State<CaregiverSearch> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> stream = _db
        .collection('caregivers')
        .orderBy('name')
        .limit(100)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text('Caregiver Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name, skill, or location',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                // Client-side filter: simple, case-insensitive contains match
                final filtered = docs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final name = (data['name'] ?? '').toString().toLowerCase();
                  final skills = (data['skills'] ?? '').toString().toLowerCase();
                  final location = (data['location'] ?? '').toString().toLowerCase();
                  final q = _query.toLowerCase();
                  if (q.isEmpty) return true;
                  return name.contains(q) || skills.contains(q) || location.contains(q);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No caregivers found'));
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final d = filtered[index];
                    final data = d.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'Unknown';
                    final skills = data['skills'] ?? '';
                    final rating = data['rating']?.toString() ?? '-';

                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(name.toString()),
                      subtitle: Text(skills.toString()),
                      trailing: Text(rating),
                      onTap: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(name.toString()),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Skills: ${skills.toString()}'),
                                const SizedBox(height: 8),
                                Text('Rating: $rating'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
