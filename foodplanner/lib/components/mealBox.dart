import 'package:flutter/material.dart';
import 'package:foodplanner/components/mealBoxContent.dart';
import 'package:foodplanner/components/mealBoxEmpty.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/landing_page_children_se_madpakke.dart'; // Update with the correct import
import 'package:foodplanner/components/dateTimePicker.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:provider/provider.dart';

class ReusableMealBox extends StatelessWidget {
  final Size size;
  final String imageUrl;
  final String caption;

  const ReusableMealBox({super.key, required this.size})
      : caption = 'Madpakke Tekst',
        imageUrl = 'https://cdn-icons-png.flaticon.com/512/739/739249.png';

  @override
  Widget build(BuildContext context) {
    final mealNotifier = Provider.of<MealNotifier>(context);
    return Card(
      color: AppColors.background,
      surfaceTintColor: AppColors.background,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            DateTimePickerWidget(),

            //Added listener for checking if meal is empty or not
            mealNotifier.isMealEmpty
                ? Mealboxempty(size: size)
                : Mealboxcontent(size: size, caption: caption),
          ],
        ),
      ),
    );
  }
}
