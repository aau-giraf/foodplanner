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
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import the reusable widget
import 'package:go_router/go_router.dart'; // Import GoRouter


class ParentLandingPageMadpakke extends StatelessWidget {
  const ParentLandingPageMadpakke({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    final mealNotifier = Provider.of<MealNotifier>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  // TODO read user title and display based on who is logged in 
                  'Velkommen' + ' ' + 'Forældre',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: size.height * 0.02),
                ReusableMealBox(size: size), // Use the reusable widget
                SizedBox(height: size.height * 0.02),

                mealNotifier.isMealEmpty
                    ? AddMealButton(size: size)
                    : CustomButton(
                  onTab: () {
                    GoRouter.of(context).go(FEEDBACK_Page, extra: {'from': PARENT_ROOT});;
                  }, 
                  text: 'Se Feedback',
                  //fontSize: 16,
                  customWidth: size.width * 0.6,
                ),
              ],
            ),
          ),
          FooterBar(), // Add the footer widget here
        ],
      ),
    );
  }
}