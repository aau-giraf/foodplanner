// login.dart
import 'package:flutter/material.dart';
import 'package:foodplanner/main.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:go_router/go_router.dart';

class SignupPage2 extends StatelessWidget {
  const SignupPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('signup page '),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the sgnup Page!'),
            ElevatedButton(
              onPressed: () {
                // Implement your login logic here, for example:
                // context.go('/home'); // Navigate to home page on successful login
                context.go(SIGNUP_PAGE);
              },
              child: const Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
