import 'package:flutter/material.dart';
import 'package:foodplanner/components/nav_bar.dart';

class StudentPage extends StatelessWidget {
   const StudentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Student Page!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text('Click Me'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
