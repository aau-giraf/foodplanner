import 'package:flutter/material.dart';
import 'package:foodplanner/components/edit_meal_ingredient_list_element.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/components/packed_ingredient.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:go_router/go_router.dart';

/// This class is used to create the page for editing an already existing meal.
class EditMealPage extends StatelessWidget {
  final int mealID; // The identifier of the meal which is being edited.

  static const String routeName = '/edit_meal_page';
  
  const EditMealPage({
    super.key,
    required this.mealID,
  });

  @override
  Widget build(BuildContext context) {
    // List<Ingredient> ingredients = <Ingredient>[ // The list containing the ingredients of the meal.
    //   Ingredient(name: "Knækbrød"),   /// TEST ///
    //   Ingredient(name: "Æble"),       /// TEST ///
    // ];

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

      // !!! Chat GPT !!!
      // Use FutureBuilder to handle the asynchronous fetchMeal
      body: FutureBuilder<Meal>(
        future: fetchMeal(mealID), // Fetch the meal asynchronously
        builder: (BuildContext context, AsyncSnapshot<Meal> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show a loader while waiting
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Show error if any
          } else if (snapshot.hasData) {
            final Meal meal = snapshot.data!;
            return FutureBuilder<List<Ingredient>>(
              future: _fetchIngredients(meal.getPackedIngredients),
              builder: (BuildContext context, AsyncSnapshot<List<Ingredient>> ingredientsSnapshot) {
                if (ingredientsSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator()); // Show loader while fetching ingredients
                } else if (ingredientsSnapshot.hasError) {
                  return Center(child: Text('Error: ${ingredientsSnapshot.error}')); // Show error if fetching ingredients fails
                } else if (ingredientsSnapshot.hasData) {
                  final ingredients = ingredientsSnapshot.data!;
                  return _buildEditMealPage(context, ingredients); // Build the page with ingredients
                } else {
                  return const Center(child: Text('No ingredients found.'));
                }
              },
            );
          } else {
            return const Center(child: Text('No meal found.'));
          }
        },
      ),
    );
  }

  // !!! Chat GPT !!!
  // Helper method to fetch ingredients asynchronously
  Future<List<Ingredient>> _fetchIngredients(List<PackedIngredient> packedIngredients) async {
    List<Ingredient> ingredients = [];
    for (var packedIngredient in packedIngredients) {
      final ingredient = await fetchIngredient(packedIngredient.ingredientRef as int);
      ingredients.add(ingredient); // Await each fetchIngredient and add to the list
    }
    return ingredients;
  }
  
  // Helper method to build the Edit Meal Page after ingredients are fetched
  Widget _buildEditMealPage(BuildContext context, List<Ingredient> ingredients) {
    return Padding(
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
              context.go(ADD_INGREDIENT_PAGE); 
            },
            widget: Icon(Icons.add, color: AppColors.textSecondary),
            backgroundColor: AppColors.secondary,
            width: MediaQuery.sizeOf(context).width/2,
          ),

          // The button for saving the changes made to meal.
          CustomElevatedButton(
            onTab: () { 
              context.pop();
            },
            width: MediaQuery.sizeOf(context).width/2,
            widget: const Text(
              'Gem ændringer',
              style: AppTextStyles.buttonText,
            ),
          ),
        ],
      ),
    );
  }
}