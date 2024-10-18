import 'package:flutter/material.dart';
import 'package:foodplanner/components/empty_meal_list_element.dart';
import 'package:foodplanner/components/meal_list_element.dart';
import 'package:foodplanner/components/meal.dart';

class MealListPage extends StatelessWidget {
  const MealListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    dynamic meals = <Meal>[
      // Meal(title: 'Knækbrød med ost + frugt', date: DateTime.now())
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded (
              child: meals.isEmpty ? EmptyMealListElement() : ListView.separated(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  return MealListElement(meal: meals[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
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