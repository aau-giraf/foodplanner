import 'package:flutter/material.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/components/ingredient_list.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/choose_ingredient_page.dart';

class AddIngredientPage extends StatelessWidget {
  final Meal meal;

  const AddIngredientPage({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redigér madpakke"),
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
              child: IngredientList(
                interactive: true,
                ingredients: meal.ingredients,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),

            SizedBox(height: 20),

            Container (
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                    BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(0, 2), // changes position of shadow
                    ),
                  ],
              ),
              child: CustomAddButton(
                onTab: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChooseIngredientPage()),
                );
                },
                width: MediaQuery.sizeOf(context).width/2,
              ),
            ),
          ]
        )
      )
    );
  }
}