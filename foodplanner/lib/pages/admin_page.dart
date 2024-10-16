import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
   const AdminPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Admin Page',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text('Manage Users'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text('Manage Content'),
            ),
          ],
        ),
      ),
    );
  }
}
