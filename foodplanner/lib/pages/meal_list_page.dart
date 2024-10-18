import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/components/meal_list.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/choose_ingredient_page.dart';

class MealListPage extends StatelessWidget {

  const MealListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              child: MealList(
                meals: <Meal>[
                  Meal(title: 'Knækbrød med ost + frugt', date: DateTime.now())
                  ],
              ),
            ),
          ]
        )
      )
    );
  }
}