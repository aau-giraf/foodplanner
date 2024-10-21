import 'package:flutter/material.dart';
import '/pages/mealPage.dart';
import '/pages/profilePage.dart';
import '/pages/settingsPage.dart';

import 'package:foodplanner/config/colors.dart';

/// This class is used to create the home page of the app.
///
/// It is also where the navigation bar is located.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// The state which contains all of the UI elements for the home page.
class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  final List<Widget> _pages = [
    // The list for all the different pages that are accessed from the navigation bar.
    const Center(child: Text('Temporary Home Page')),
    const MealPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          // The index is changed and set to match the index of the clicked page.
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: AppColors.primary,
        selectedIndex: currentPageIndex,
        destinations: const <NavigationDestination>[
          // This is where the buttons for the navigation bar are made.
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Hjem',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory),
            label: 'Måltider',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Indstillinger',
          ),
        ],
      ),
      body: _pages[
          currentPageIndex], // Sets the shown page to be the selected index.
    );
  }
}
