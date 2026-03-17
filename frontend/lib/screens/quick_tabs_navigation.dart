import 'package:flutter/material.dart';

import 'home_tab.dart';
import 'explore_tab.dart';
import 'location_preview_screen.dart';
import 'notifications_screen.dart';
import 'profile_tab.dart';

/// QuickTabs Navigation — uses BottomNavigationBar + PageView + PageController
/// to deliver smooth, swipeable, state-preserving tab navigation.
///
/// Key design choices:
///  • PageView keeps all three child screens alive so their state (scroll
///    position, form input, stream data) is preserved across tab switches.
///  • PageController.animateToPage provides a smooth sliding transition when
///    a bottom tab is tapped.
///  • onPageChanged keeps the highlighted tab in sync when the user swipes.
class QuickTabsNavigation extends StatefulWidget {
  const QuickTabsNavigation({super.key});

  @override
  State<QuickTabsNavigation> createState() => _QuickTabsNavigationState();
}

class _QuickTabsNavigationState extends State<QuickTabsNavigation> {
  int _currentIndex = 0;

  // PageController drives the PageView and enables animated transitions.
  final PageController _pageController = PageController();

  // Screen list is defined outside build() to avoid re-creation on every
  // rebuild — this is a recommended best practice.
  final List<Widget> _screens = const [
    HomeTab(),
    ExploreTab(),
    LocationPreviewScreen(),
    NotificationsScreen(),
    ProfileTab(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Called when a BottomNavigationBar item is tapped.
  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Called when the PageView page changes (by swipe or animation).
  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- PageView body: enables swiping + keeps child state alive ---
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),

      // --- BottomNavigationBar ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 13,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
