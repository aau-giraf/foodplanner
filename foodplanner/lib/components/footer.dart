import 'package:flutter/material.dart';
import 'package:foodplanner/pages/login_page.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:go_router/go_router.dart';

class FooterBar extends StatefulWidget {
  @override
  _FooterBarState createState() => _FooterBarState();
}

class _FooterBarState extends State<FooterBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    switch (index) {
      case 0:
        GoRouter.of(context).go(FEEDBACK_Page);
        break;
      case 1:
        GoRouter.of(context).go(PARENT_ROOT);
        break;
      case 2:
        GoRouter.of(context).go(PROFILE_PAGE);
        break;
      case 3:
        GoRouter.of(context).go(SETTINGS_PAGE);
        break;
      default:
        page = LoginPage();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lunch_dining_outlined),
          label: 'Meal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
      //TODO when group10 is done we can implement colour change upon click
      selectedItemColor: Colors.black, // Set color for the selected icon
      unselectedItemColor: Colors.black, // Set color for unselected icons
    );
  }
}