import 'package:flutter/material.dart';

import 'package:foodplanner/components/mealBox.dart';

import 'package:foodplanner/pages/pin_code.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:provider/provider.dart';


class ChildLandingPageMadpakke extends StatelessWidget {
  const ChildLandingPageMadpakke({super.key, required Map<String, String> student});

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: size.width * 0.9,  // Adjust width percentage as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Velkommen Barn',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.05),
                        ReusableMealBox(size: size),
                        SizedBox(height: size.height * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (authProvider.hasRole([ROLES.parent]) || authProvider.hasRole([ROLES.child]))
          Positioned(
            top: -8,
            right: 30,
            child: IconButton(
              icon: Icon(Icons.lock_outline, size: 40, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PinCode()),
                );  
              },
            ),
          ),
        ],
      ),
    );
  }
}