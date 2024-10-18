import 'package:flutter/material.dart';
import 'package:foodplanner/components/edit_meal_ingredient_list_element.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class EditMeal extends StatelessWidget {
  final Meal meal;
  
  const EditMeal({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    List<Ingredient> ingredients = <Ingredient>[
      Ingredient(name: "Knækbrød"),
      Ingredient(name: "Æble"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rediger madpakke"),
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
      
      body: Padding(
        padding: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 12),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: ingredients.length,
                itemBuilder: (BuildContext context, int index) {
                  return EditMealIngredientListElement(ingredient: ingredients[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20,);
                },
              ),
            ),
            
            CustomElevatedButton(
              onTab: () {

              },
              widget: Icon(Icons.add, color: AppColors.textSecondary),
              backgroundColor: AppColors.secondary,
              width: MediaQuery.sizeOf(context).width/2,
            ),

            CustomElevatedButton(
              onTab: () {

              },
              width: MediaQuery.sizeOf(context).width/2,
              widget: const Text(
                'Gem ændringer',
                style: AppTextStyles.buttonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}