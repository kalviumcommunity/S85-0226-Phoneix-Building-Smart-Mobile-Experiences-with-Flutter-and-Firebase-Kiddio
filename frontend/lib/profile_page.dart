import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  Future<void> _editExperience(BuildContext context, int currentExperience) async {
    final TextEditingController controller = TextEditingController(text: currentExperience.toString());
    
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Years of Experience'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Enter years of experience"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final int? newExperience = int.tryParse(controller.text);
                if (newExperience != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .update({'yearsOfExperience': newExperience});
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User not found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final int experience = data['yearsOfExperience'] ?? 0;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${data['name'] ?? ''}",
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text("Email: ${data['email'] ?? ''}"),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text("Years of Experience: $experience"),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editExperience(context, experience),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}