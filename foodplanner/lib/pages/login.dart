// login.dart
import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/pages/home_page.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../routes/user_roles.dart';


class LoginPage2 extends StatelessWidget {
  const LoginPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the Login Page!'),
            ElevatedButton(
              onPressed: () {
                // Implement your login logic here, for example:
                // context.go('/home'); // Navigate to home page on successful login
              },
              child: const Text('login'),
              
            ),
            ElevatedButton(
              onPressed: () {
              context.go(SIGNUP_PAGE); // Navigates to the login page
              },
              child: const Text('signup'),
            ),
            ElevatedButton(
              onPressed: () {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                authProvider.setRole(ROLES.admin);},
              child: const Text('Set role to admin'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go(ADMIN_ROOT); 
              },
              child: const Text('Go to admin page'),
            ),
             const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: const Text('Go to home page'),
            ),
          ],
        ),
      ),
    );
  }
}



