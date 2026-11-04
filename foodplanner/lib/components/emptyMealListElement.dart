import 'package:flutter/material.dart';
import 'package:foodplanner/config/month_picker.dart';
import 'package:foodplanner/config/text_styles.dart';

/// This class is used to create the element for when no meals are found.
class EmptyMealListElement extends StatelessWidget {
  const EmptyMealListElement({
    super.key, // Constructor with a key for identifyning the widget
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container that holds the no-meal-found message and UI
        Container( 
          width: MediaQuery.sizeOf(context).width, // Full width of the device
          height: 120, // Fixed height fir the container
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24), // Rounded corners for the container
            //border: Border.all(color: Colors.grey),
            color: Color(0xffF2F2F2), // Light gray background color
            boxShadow: [
              // Adding a shadow effect for a raised appearnce
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5), // Shadow color with opacity
                spreadRadius: 1, // Spread amount of the shadow
                blurRadius: 1, // Bkyr raduus fir siftening the shadow
                offset: const Offset(0, 2), // Offset of the shadow
              ),
            ],
          ),
          child: Padding(
            // Padding inside the container for spacing
            padding: const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 25),
            child: Column(
              children: [
                // The text displaying the date of the meal.
                Text(
                  'Madpakke i dag d. ${DateTime.now().day.toString()}. ${MonthPicker.pick(DateTime.now().month)}',
                  style: AppTextStyles.standard, // Text style
                ),

                SizedBox(height: 20), // Spacer between the texts

                // The text saying that no meals were found.
                Text(
                  'Ingen madpakke at vise',
                  style: AppTextStyles.headline1, // Text style for the headline 
                ),
              ]
            ),
          ),
        ),
      ],
    );
  }
}