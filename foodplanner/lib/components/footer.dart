import 'package:flutter/material.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/pages/feedbackChatPage.dart';
import 'package:foodplanner/pages/landing_page_children_madpakke.dart';
import 'package:foodplanner/pages/login_page.dart';


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
        page = FeedbackChatPage();
        break;
      case 1:
        page = ChildLandingPageMadpakke();
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
      selectedItemColor: Colors.orange,  // Set color for the selected icon
      unselectedItemColor: Colors.black,  // Set color for unselected icons
    );
  }
}
