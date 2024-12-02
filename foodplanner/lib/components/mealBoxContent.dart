import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/pages/landing_page_children_se_madpakke.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:provider/provider.dart'; // Update with the correct import

class Mealboxcontent extends StatelessWidget {
  final String caption;

  const Mealboxcontent({super.key, this.caption = 'Madpakke Text'});

  @override
  Widget build(BuildContext context) {
    return Consumer<MealNotifier>(
      builder: (context, mealNotifier, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                caption,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FoodImage(foodImageId: mealNotifier.meal!.foodImageId),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: CustomButton(
                onTab: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChildLandingPageSeMadpakke()),
                  );
                },
                text: 'Se madpakke',
                size: ButtonSize.medium,
              ),
            ),
          ],
        );
      },
    );
  }
}
