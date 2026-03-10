import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../state/favorites_provider.dart';
import 'profile_details_form.dart';

/// Profile Tab — shows user info and sign-out option.
/// State is preserved across tab switches thanks to PageView.
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final favorites = context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- Avatar ---
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                (user?.email ?? '?')[0].toUpperCase(),
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // --- Email ---
            Text(
              user?.email ?? 'Not signed in',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'UID: ${user?.uid ?? 'N/A'}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // --- Favorites count ---
            _InfoTile(
              icon: Icons.favorite,
              label: 'Favorites',
              value: '${favorites.length}',
            ),
            const Divider(),

            // --- Firestore profile data ---
            if (user != null)
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snap.hasData || !snap.data!.exists) {
                    return const _InfoTile(
                      icon: Icons.info_outline,
                      label: 'Profile Data',
                      value: 'Not set up yet',
                    );
                  }
                  final data = snap.data!.data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      _InfoTile(
                        icon: Icons.person,
                        label: 'Name',
                        value: data['name'] ?? '—',
                      ),
                      const Divider(),
                      _InfoTile(
                        icon: Icons.work,
                        label: 'Experience',
                        value: '${data['yearsOfExperience'] ?? 0} years',
                      ),
                      const Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('Edit Profile Details'),
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              ProfileDetailsFormScreen.routeName,
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sign Out',
                    style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small helper widget for profile info rows.
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      trailing: Text(value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
    );
  }
}
