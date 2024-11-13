import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/edit_meal_element.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/services/food_image_service.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:foodplanner/services/packed_ingredient_services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// This class is used to create the page for editing an already existing meal.
class EditMealFormPage extends StatelessWidget {
  final Meal meal; // The identifier of the meal which is being edited.
  final List<PackedIngredient> packedIngredients;
  final List<Ingredient>? ingredients;
  final Client client;
  final MultipartFile? image;

  final VoidCallback onAddIngredients; // Callback to change the shown page through "add_ingredient_page.dart"
  final VoidCallback onCamera; // Callback to change the shown page through "camera_page.dart"
  
  const EditMealFormPage({
    super.key, // Key for the widget, used for maintaining state.
    required this.meal, // Required parameter for the meal being edited.
    required this.packedIngredients,
    required this.ingredients, // Required parameter for the ingredients used in the meal.
    required this.onAddIngredients, // Required callback for adding new ingredients.
    required this.onCamera,  // Required callback for opening the camera page.
    required this.client,
    required this.image,
  });


  static const String routeName = '/edit_meal_form_page'; // Route name for navigation to this page.

  @override
  Widget build(BuildContext context) {
    // List<Ingredient> ingredients = <Ingredient>[ // The list containing the ingredients of the meal.
    //   Ingredient(name: "Knækbrød"),   /// TEST ///
    //   Ingredient(name: "Æble"),       /// TEST ///
    // ];

    return Scaffold( // Scaffold provides the basic visual structure for the page.
      body: _buildEditMealPage(context, ingredients ?? []) // Build the edit meal page with the ingredients.
    );
  }
  
  // Helper method to build the Edit Meal Page after ingredients are fetched
  Widget _buildEditMealPage(BuildContext context, List<Ingredient> ingredients) {
    TextEditingController editTitleController = TextEditingController(text: meal.title);

    return Padding( // Padding applied around the content inside the column.
      padding: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 12), // Define the padding in all directions.
      child: Column( // Vertical layout for the page.
        children: [
          EditMealElement(meal: meal, onCamera: onCamera, editTitleController: editTitleController),

          // The button for adding a new ingredient to the meal.
          CustomElevatedButton(
            onTab: () { // Leads to the "add_ingredient_page"
              onAddIngredients(); // Calls the callback to change to the "add_ingredient_page".
            },
            widget: Icon(Icons.add, color: AppColors.textSecondary),  // Icon displayed on the button.
            backgroundColor: AppColors.tertiary, // Background color of the button.
            width: MediaQuery.sizeOf(context).width/2, // Half the width of the screen for the button.
          ),
          Spacer(),

          // The button for saving the changes made to meal.
          CustomElevatedButton(
            onTab: () async {
              final authProvider = AuthProvider();
              int? imageId = this.image != null ? 
                int.parse((await UploadFoodImage(
                  http.Client(),
                  this.image!
                )).body): null;
              updateMeal(client, authProvider, Meal(
                id: meal.id,
                title: editTitleController.text,
                imageRef: imageId,
                date: meal.date,
                ingredients: [],
              ));
              final ingredientsToAdd = packedIngredients.where((element) => element.id == 0);
              ingredientsToAdd.forEach((ingredientToAdd) {
                createPackedIngredient(
                  client,
                  authProvider,
                  meal.id,
                  ingredientToAdd.ingredientRef.id,
                );
              });
              final ingredientsToRemove = packedIngredients.where((element) => meal.ingredients.contains(element));
              ingredientsToRemove.forEach((ingredientToRemove) {
                deletePackedIngredient(
                  client, 
                  authProvider, 
                  meal.id
                );
              });

              // context.pop(); // Goes back to the previous page.
            },
            width: MediaQuery.sizeOf(context).width/2, // Half the width of the screen for saving button.
            widget: const Text( // Text displayed on the button.
              'Gem ændringer',
              style: AppTextStyles.buttonText,  // Style for the text.
            ),
          ),
        ],
      ),
    );
  }
}