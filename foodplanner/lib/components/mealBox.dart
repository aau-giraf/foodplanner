import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/mealBoxContent.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/landing_page_children_se_madpakke.dart'; // Update with the correct import
import 'package:foodplanner/components/dateTimePicker.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:provider/provider.dart';

class ReusableMealBox extends StatelessWidget {
  const ReusableMealBox({super.key});

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () => mealNotifier.selectDate(context),
                overlayColor: WidgetStatePropertyAll(AppColors.primary),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DateTimePickerWidget(),
                      SFIcon(SFIcons.sf_calendar, fontSize: 36),
                    ],
                  ),
                ),
              ),
            ),
            if (mealNotifier.meal == null)
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // sabrina carpenter tho :flushedEmoj:
                  const Text(
                    'ingen madpakke at vise',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            else
              Mealboxcontent(caption: mealNotifier.meal!.name)
          ],
        ),
      ),
    );
  }
}
