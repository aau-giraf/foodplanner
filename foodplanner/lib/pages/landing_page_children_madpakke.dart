import 'package:flutter/material.dart';
import 'package:foodplanner/components/dateTimePicker.dart';
import 'package:foodplanner/components/mealBox.dart';
import 'package:foodplanner/components/mealBoxContent.dart';
import 'package:foodplanner/components/mealBoxEmpty.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:intl/intl.dart'; // Import the reusable widget

class ChildLandingPageMadpakke extends StatelessWidget {
  const ChildLandingPageMadpakke({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              // TODO read user title and display based on who is logged in 
              'Welcome' + ' ' + 'Child',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: size.height * 0.02),
            ReusableMealBox(size: size), // Use the reusable widget
          ],
        ),
      ),
    );
  }
}