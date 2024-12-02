import 'package:flutter/material.dart';
import 'package:foodplanner/components/date_time_picker.dart';
import 'package:foodplanner/components/meal_box_content.dart';
import 'package:foodplanner/components/meal_box_empty.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:provider/provider.dart';

class ReusableMealBox extends StatelessWidget {
  final Size size;
  final String imageUrl;
  final String caption;

  const ReusableMealBox({Key? key, required this.size})
      : caption = 'Madpakke Tekst',
        imageUrl =
            'https://cdn-icons-png.flaticon.com/512/739/739249.png', // when we fetch we change here so the result is displayed (the picture from minio)
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final mealNotifier = Provider.of<MealNotifier>(context);
    return Container(
      width: size.width * 0.9, // 90% of the screen width
      // if meal empty the grey box is smaller
      height: mealNotifier.isMealEmpty
          ? size.height * 0.2
          : size.height * 0.1 +
              size.width * 0.6 +
              190, // "dynamic" height, if mealbox is empty its smaller
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color.fromARGB(
            255, 243, 243, 243), // image box background color
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          // love sabrina carpenter
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DateTimePickerWidget(),

          //Added listener for checking if meal is empty or not
          mealNotifier.isMealEmpty
              ? MealBoxEmpty(size: size)
              : MealBoxContent(size: size, caption: caption),
        ],
      ),
    );
  }
}
