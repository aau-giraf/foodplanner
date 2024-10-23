import 'package:flutter/material.dart';
import 'package:foodplanner/pages/create_child_page.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/pages/login_page.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
              'HOME PAGE HOME PAGE',
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
            // Used for development purposes
            ElevatedButton(
              onPressed: () {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                authProvider.setRole(ROLES.admin);
              },
              child: const Text('Set role to admin'),
            ),
            ElevatedButton(
              onPressed: () {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                if (authProvider.hasRole(ROLES.admin)) {
                  context.go(ADMIN_ROOT);
                } else {
                  context.go('/unauthorized');
                }
              },
              child: const Text('Go to Admin Page'),
            ),

            // ElevatedButton(
            // onPressed: () async {
            //   final authProvider = Provider.of<AuthProvider>(context, listen: false);
            //   await authProvider.login(ROLES.admin, AuthProvider().jwtToken, AuthProvider().isLoggedIn); // token has to come from backend :) so when stokholm fix his shit we can fix ours
            //   print('Logged in: ${authProvider.isLoggedIn}');
            //   print('User Role: ${authProvider.userRole}');
            //   print('JWT Token: ${authProvider.jwtToken}');
            // },
            // child: const Text('Login TESTING TOKENS'),
            // ),
            ElevatedButton(
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider
                    .logout(); // Just call it; don't try to store a result
                print('Logged out'); // For debugging purposes
              },
              child: const Text('Logout'),
            ),

            ElevatedButton(
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                final token = await authProvider.retrieveToken();
                print('Retrieved JWT Token: $token');
              },
              child: const Text('Retrieve Token'),
            ),
          ],
        ),
      ),
    );
  }
}
