import 'package:flutter/material.dart';
import 'package:foodplanner/components/addMealButton.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/dateTimePicker.dart';
import 'package:foodplanner/components/mealBox.dart';
import 'package:foodplanner/components/mealBoxContent.dart';
import 'package:foodplanner/components/mealBoxEmpty.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/feedbackChatPage.dart';
import 'package:foodplanner/components/footer.dart'; // Import the footer widget
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import the reusable widget

class ChildLandingPageMadpakke extends StatelessWidget {
  const ChildLandingPageMadpakke({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: size.width * 0.9, // if other pages get skewed then you can do this OR its something to do with reusableMealBox.dart
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Velkommen Forældre',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: size.height * 0.02),
                    ReusableMealBox(size: size),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}