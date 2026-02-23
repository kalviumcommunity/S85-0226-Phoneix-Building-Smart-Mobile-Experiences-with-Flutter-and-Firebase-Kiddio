import 'package:flutter/material.dart';
import '../widgets/info_card.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: Center(
        child: InfoCard(
          title: 'Account Info',
          subtitle: 'User details and subscription',
          icon: Icons.info,
        ),
      ),
    );
  }
}
