import 'package:flutter/material.dart';
import '/pages/mealPage.dart';
import '/pages/profilePage.dart';
import '/pages/settingsPage.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override Widget build(BuildContext context) {
    return const MaterialApp(home: HomePageExample());
  }
}

class HomePageExample extends StatefulWidget {
  const HomePageExample({super.key});

  @override 
  State<HomePageExample> createState() => 
  _HomePageState(); 
}

class _HomePageState extends State<HomePageExample> {
  int currentPageIndex = 0;

   final List<Widget> _pages = [
    const Center(child: Text('Home Page')),
    const MealPage(),
    const ProfilePage(),
    const SettingsPage(),
  ];


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home), 
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory), 
            label: 'Meals',
          ),
          NavigationDestination(
            icon: Icon(Icons.person), 
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings), 
            label: 'Settings',
          ),
        ],
      ),
      // body: <Widget>[
      //     // Det er her hvor navigator index'ere siderne
      // ][currentPageIndex],
      body: _pages[currentPageIndex],
    );
  }
}
