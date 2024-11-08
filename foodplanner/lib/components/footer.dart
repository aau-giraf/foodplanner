import 'package:flutter/material.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/pages/feedbackChatPage.dart';
import 'package:foodplanner/pages/landing_page_children_madpakke.dart';
import 'package:foodplanner/pages/landing_page_parent.dart';
import 'package:foodplanner/pages/login_page.dart';
import 'package:foodplanner/pages/profile.dart';
import 'package:foodplanner/pages/profilePage.dart';
import 'package:foodplanner/pages/settingsPage.dart';
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
        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackChatPage()),
                    );
        break;
      case 1:
      /*
      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ParentLandingPageMadpakke()),
                    );
                    */
                    GoRouter.of(context).go(PARENT_ROOT);
        break;
      case 2:
      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
        break;
      case 3:
      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
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
      selectedItemColor: Colors.black,  // Set color for the selected icon
      unselectedItemColor: Colors.black,  // Set color for unselected icons
    );
  }
}
