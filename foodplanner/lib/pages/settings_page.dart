import 'package:flutter/material.dart';
import 'package:foodplanner/components/footer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Column(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Ensure footer is at the bottom
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Settings page content will be implemented here.',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ), // Add the footer widget here
        ],
      ),
    );
  }
}
