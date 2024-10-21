import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  bool isLocked = true;

  void handleLock() {
    setState(() {
      isLocked = !isLocked;
    });
    if (!isLocked) {
      context.go('/pin_code');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await authProvider.loadFromStorage();
      print("Auth: ${authProvider.isLoggedIn}");
      print("Approved: ${authProvider.isApproved}");
      if (!authProvider.isLoggedIn) {
        context.go(LOGIN_PAGE);
      } else if (authProvider.isApproved != true) {
        context.go('/unauthorized');
      }
    });

    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: handleLock,
                  icon: SFIcon(
                    isLocked ? SFIcons.sf_lock_fill : SFIcons.sf_lock_open_fill,
                  )),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  await authProvider
                      .logout(); // Just call it; don't try to store a result
                  print('Logged out'); // For debugging purposes
                  context.go(LOGIN_PAGE);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
