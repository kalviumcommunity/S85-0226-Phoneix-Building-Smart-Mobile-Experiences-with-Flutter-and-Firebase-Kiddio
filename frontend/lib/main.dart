import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screen.dart';
import 'screens/quick_tabs_navigation.dart';
import 'screens/profile_details_form.dart';
import 'screens/location_preview_screen.dart';
import 'screens/live_items_viewer_screen.dart';
import 'state/favorites_provider.dart';
import 'task_list_page.dart';
import 'theme/colors.dart';
import 'profile_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Night Mode: 10pm-6am
    final now = DateTime.now();
    final isNightMode = now.hour >= 22 || now.hour < 6;

    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: isNightMode ? kNightColorScheme : kColorScheme,
          appBarTheme: AppBarTheme(
            backgroundColor: isNightMode ? kNightColorScheme.primary : kPrimaryColor,
            foregroundColor: isNightMode ? kNightColorScheme.onPrimary : Colors.white,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: isNightMode ? kNightColorScheme.secondary : kAccentColor,
            foregroundColor: isNightMode ? kNightColorScheme.onSecondary : Colors.black,
          ),
        ),
        routes: {
          '/login': (ctx) => const AuthScreen(),
          '/home': (ctx) => const TaskListPage(),
          '/profile': (ctx) {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) return const AuthScreen();
            return ProfilePage(userId: user.uid);
          },
          ProfileDetailsFormScreen.routeName: (ctx) =>
              const ProfileDetailsFormScreen(),
          LocationPreviewScreen.routeName: (ctx) =>
              const LocationPreviewScreen(),
            LiveItemsViewerScreen.routeName: (ctx) =>
              const LiveItemsViewerScreen(),
        },

        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!snapshot.hasData) {
              return const AuthScreen();
            }

            return const QuickTabsNavigation();
          },
        ),
      ),
    );
  }
}

