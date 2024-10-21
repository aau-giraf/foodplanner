import 'package:flutter/material.dart';
import 'package:foodplanner/components/empty_meal_list_element.dart';
import 'package:foodplanner/components/meal_list_element.dart';
import 'package:foodplanner/components/meal.dart';

/// This class is used for creating the page, where the user can see all their meals.
class MealListPage extends StatelessWidget {
  const MealListPage({
    super.key,
  });

  static const String routeName = '/meal_list_page';

  @override
  Widget build(BuildContext context) {
    dynamic meals = <Meal>[ // List of meals that will be shown
      // Meal(title: 'Knækbrød med ost + frugt', date: DateTime.now())     /// TEST ///
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Velkommen, ."),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Meal elements are added to the page.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded (
              child: meals.isEmpty ? EmptyMealListElement() : ListView.separated( // Shows the empty list element if there exists no meals. Otherwise, it will show all meals for the user.
                itemCount: meals.length,
                itemBuilder: (context, index) { // Runs for the amount of elements that exists in the meals list.
                  return MealListElement(meal: meals[index]);
                },
                separatorBuilder: (BuildContext context, int index) { // Creates spacing between the elements.
                  return const SizedBox(height: 10);
                },
              ),
            ),
          ]
        )
      )
    );
  }
}