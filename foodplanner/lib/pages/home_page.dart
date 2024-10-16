import 'package:flutter/material.dart';
import 'package:foodplanner/pages/create_child_page.dart';
import 'package:foodplanner/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final String title = 'Home Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Text(
              'Du er nu logget ind!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Go to Login Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateChildPage()),
                );
              },
              child: const Text('Go to Child Creation Page'),
            ),
          ],
        ),
      ),
    );
  }
}
