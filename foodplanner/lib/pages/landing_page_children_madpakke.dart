import 'package:flutter/material.dart';
import 'package:foodplanner/components/addMealButton.dart';
import 'package:foodplanner/components/button.dart';
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

    final bool isMadpakkeEmpty = true; // Later we want to check with a fetch whether there is a box or not


    // Placeholder function for the feedback button
    void _navigateToFeedback() {
      // For now, just print a message or show a snackbar
      print('Feedback button pressed');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback page not implemented yet')),
      );
    }


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
            SizedBox(height: size.height * 0.02),

            isMadpakkeEmpty
                ? AddMealButton(size: size)
                : CustomButton(
              onTab: _navigateToFeedback, // Use the placeholder function
              text: 'Se Feedback',
              fontSize: 16,
              width: size.width * 0.6,
            ),
            
            
          ],
        ),
      ),
    );
  }
}