import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import 'details_screen.dart';
import 'firestore_demo.dart';
import 'responsive_layout.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'stateless_stateful_demo.dart';


class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;
    final isTablet = screenWidth > 600;

    final horizontalPadding = isTablet ? 24.0 : screenWidth * 0.06;
    final titleSize = isTablet ? 28.0 : 20.0;
    final bodySize = isTablet ? 18.0 : 14.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Home'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
          ,
          IconButton(
            tooltip: 'Stateless/Stateful Demo',
            icon: const Icon(Icons.toggle_on),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatelessStatefulDemo())),
          ),
          IconButton(
            tooltip: 'Firestore Demo',
            icon: const Icon(Icons.storage),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FirestoreDemo())),
          ),
          IconButton(
            tooltip: 'Responsive Layout Demo',
            icon: const Icon(Icons.dashboard),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ResponsiveLayout())),
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (isTablet) {
          // Tablet / wide layout: two columns
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome', style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                        'This layout demonstrates a two-column adaptive UI using MediaQuery and LayoutBuilder. Resize the window or rotate the device.',
                        style: TextStyle(fontSize: bodySize),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 3 / 2,
                          ),
                          itemCount: 6,
                          itemBuilder: (context, index) => InfoCard(
                            title: 'Card ${index + 1}',
                            subtitle: 'Adaptive content flows here.',
                            icon: Icons.devices,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailsScreen())),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: screenHeight * 0.28,
                        decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(8)),
                        child: Center(child: Text('Detail Panel', style: TextStyle(fontSize: bodySize + 2))),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailsScreen())),
                        icon: const Icon(Icons.navigation),
                        label: const Text('Primary Action'),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: 4,
                          itemBuilder: (context, i) => ListTile(
                            leading: const Icon(Icons.check_circle_outline),
                            title: Text('Option ${i + 1}'),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }

        // Phone / narrow layout: single column
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Welcome', style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(
                  'This layout adapts using MediaQuery. Rotate the device or use a larger screen to see a different arrangement.',
                  style: TextStyle(fontSize: bodySize),
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Icon(Icons.phone_iphone, size: 48)),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      width: (screenWidth - horizontalPadding * 2 - 16) / 2,
                      child: InfoCard(
                        title: 'Item ${index + 1}',
                        subtitle: 'Tap to view details',
                        icon: Icons.label_outline,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailsScreen())),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailsScreen())),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Take Action', style: TextStyle(fontSize: bodySize, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Footer or supplementary info', textAlign: TextAlign.center, style: TextStyle(fontSize: bodySize * 0.9)),
              ],
            ),
          ),
        );
      }),
    );
  }
}
