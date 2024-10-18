import 'package:flutter/material.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/components/packed_ingredient.dart';
import 'package:foodplanner/config/colors.dart';

class AddIngredientPage extends StatelessWidget {
  final Meal meal;

  const AddIngredientPage({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    List<Ingredient> ingredients = <Ingredient>[

    ];
    PackedIngredient new_ingredient = PackedIngredient();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Find madvare"),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 1.0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5, right: 16, left: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Skriv her...',
                hintStyle: TextStyle(
                  color: AppColors.textFieldHint,
                ),
                filled: true,
                fillColor: AppColors.textFieldBackground,
              ),
            ),
          ),
          
          Expanded(
            child: ListView.separated(
              itemCount: ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return ElevatedButton(
                  onPressed: () {},
                  child: Text(ingredients[index].name),
                );
              }, 
              separatorBuilder: (BuildContext context, int index) {
                return Divider(color: AppColors.textFieldBorder,);
              }, 
            )
          ),
        ],
      ),
    );
  }
}