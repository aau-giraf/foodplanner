import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/image.dart';
import 'package:foodplanner/pages/landing_page_children_se_madpakke.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:provider/provider.dart';

class Mealboxcontent extends StatelessWidget {
  const Mealboxcontent({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<MealNotifier>(
      builder: (context, mealNotifier, child) {
        if (mealNotifier.meal == null) {
          return _buildNavigationArrows(mealNotifier);
        }
        return Column(
          children: [
            _buildNavigationArrows(mealNotifier), 
            SizedBox(height: 20),
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
                      builder: (context) => ChildLandingPageSeMadpakke()
                    ),
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

  /// This widget also includes the text between the arrows.
  Widget _buildNavigationArrows(MealNotifier mealNotifier) {
    final EdgeInsets horizontalInsets = EdgeInsets.symmetric(horizontal: 10);
    final double buttonHeight = 40;
    final double buttonWidth = 80;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: horizontalInsets,
          child: CustomButton(
            onTab: () => mealNotifier.updateDate(mealNotifier.selectedDate.subtract(Duration(days: 1))), 
            customHeight: buttonHeight, 
            customWidth: buttonWidth, 
            icon: SFIcon(SFIcons.sf_arrow_backward)
          ),
        ),
        Text(
          mealNotifier.meal != null ? mealNotifier.meal!.name : 'Ingen madpakke at vise',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: horizontalInsets, 
          child: CustomButton(
            onTab: () => mealNotifier.updateDate(mealNotifier.selectedDate.add(Duration(days: 1))), 
            customHeight: buttonHeight, 
            customWidth: buttonWidth, 
            icon: SFIcon(SFIcons.sf_arrow_forward)
          ),
        )
      ],
    );
  }
}