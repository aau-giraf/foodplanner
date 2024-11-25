import 'package:flutter/material.dart';
import 'package:foodplanner/components/add_meal_button.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/footer.dart'; // Import the footer widget
import 'package:foodplanner/components/meal_box.dart';
import 'package:foodplanner/pages/feedback_chat_page.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:provider/provider.dart'; // Import the reusable widget

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeedbackChatPage()),
                          );
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
