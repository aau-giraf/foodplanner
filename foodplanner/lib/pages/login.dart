// login.dart
import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:go_router/go_router.dart';
import '../routes/user_roles.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                // Log in as a teacher
                //Provider.of<AuthProvider>(context, listen: false).login(ROLES.teacher);
              },
              child: const Text('Login as Teacher'),
            ),
            ElevatedButton(
              onPressed: () {
                // Log in as a student
                //Provider.of<AuthProvider>(context, listen: false).login(ROLES.student);
              },
              child: const Text('Login as Student'),
            ),
          ],
        ),
      ),
    );
  }
}



