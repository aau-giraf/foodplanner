import 'package:flutter/material.dart';
import 'package:foodplanner/components/edit_meal_ingredient_list_element.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

/// This class is used to create the page for editing an already existing meal.
class EditMeal extends StatelessWidget {
  final Meal meal; // The meal which is being edited.
  
  const EditMeal({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    List<Ingredient> ingredients = <Ingredient>[ // The list containing the ingredients of the meal.
      Ingredient(name: "Knækbrød"),   /// TEST ///
      Ingredient(name: "Æble"),       /// TEST ///
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
            // The list of elements which are created for each of the ingredients.
            Expanded(
              child: ListView.separated(
                itemCount: ingredients.length, // Creates an element for each ingredient.
                itemBuilder: (BuildContext context, int index) {
                  return EditMealIngredientListElement(ingredient: ingredients[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 20,);
                },
              ),
            ),
            
            // The button for adding a new ingredient to the meal.
            CustomElevatedButton(
              onTab: () { // Leads to the "add_ingredient_page"

              },
              widget: Icon(Icons.add, color: AppColors.textSecondary),
              backgroundColor: AppColors.secondary,
              width: MediaQuery.sizeOf(context).width/2,
            ),

            // The button for saving the changes made to meal.
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