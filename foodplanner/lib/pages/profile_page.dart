import 'package:flutter/material.dart';
import 'package:foodplanner/components/nav_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: NavBar(currentPageIndex: 2),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Ensure footer is at the bottom
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Profile page content will be implemented here.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
