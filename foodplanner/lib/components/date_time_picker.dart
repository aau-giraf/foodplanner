import 'package:flutter/material.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateTimePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mealNotifier = Provider.of<MealNotifier>(context);
    String formattedDate =
        DateFormat('dd. MMMM').format(mealNotifier.selectedDate);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Madpakke for d. $formattedDate',
          style: TextStyle(fontSize: 16),
        ),
        mealNotifier.mealImageRef.isNotEmpty
            ? Image.network(
                mealNotifier.mealImageRef,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Image not available'));
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              )
            : Container(),
      ],
    );
  }
}
