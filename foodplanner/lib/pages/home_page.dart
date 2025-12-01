import 'package:flutter/material.dart';
import 'package:foodplanner/pages/landing_page_guardian.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'landing_page_children_madpakke.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/pages/main_page_teacher.dart';

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
                GoRouter.of(context).go('/login');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginPage()),
                // );
              },
              child: const Text('Go to Login Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PupilLandingPageMadpakke(
                            pupil: {},
                          )),
                );
              },
              child: const Text('Go to Child Landing Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GuardianLandingPageMadpakke()),
                );
              },
              child: const Text('Go to Parent Landing Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TeacherMainPage()),
                );
              },
              child: const Text('Go to Teacher Landing Page'),
            ),
            // Used for development purposes
            ElevatedButton(
              onPressed: () {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                authProvider.setRole(UserRoles.of({Role.admin}));
              },
              child: const Text('Set role to admin'),
            ),
            ElevatedButton(
              onPressed: () {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                authProvider.setRole(UserRoles.of({Role.guardian}));
              },
              child: const Text('Set role to parent'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go(ADMIN_ROOT);
              },
              child: const Text('Go to Admin Page'),
            ),
            ElevatedButton(
              onPressed: () {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                if (authProvider.userRole?.hasRole(Role.guardian) ?? false) {
                  context.go(NO_MEAL);
                } else {
                  context.go('/unauthorized');
                }
              },
              child: const Text('Go to No Meal Page'),
            ),
            ElevatedButton(
              onPressed: () {
                context.go(EDIT_MEAL);
              },
              child: const Text('Go to Edit Meal Page'),
            ),
            ElevatedButton(
              onPressed: () async {
                final authProvider =
                    Provider.of<AuthProvider>(context, listen: false);
                await authProvider
                    .logout(); // Just call it; don't try to store a result
              },
              child: const Text('Logout'),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthProvider().retrieveToken();
              },
              child: const Text('Retrieve Token'),
            ),
          ],
        ),
      ),
    );
  }
}
