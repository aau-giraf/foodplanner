import 'package:flutter/material.dart';
import 'package:foodplanner/components/edit_meal_element.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

/// This class is used to create the page for editing an already existing meal.
class EditMealFormPage extends StatelessWidget {
  final Meal meal; // The identifier of the meal which is being edited.
  final List<Ingredient>? ingredients;
  final Client client;

  final VoidCallback onAddIngredients; // Callback to change the shown page through "add_ingredient_page.dart"
  final VoidCallback onCamera; // Callback to change the shown page through "camera_page.dart"
  
  const EditMealFormPage({
    super.key, // Key for the widget, used for maintaining state.
    required this.meal, // Required parameter for the meal being edited.
    required this.ingredients, // Required parameter for the ingredients used in the meal.
    required this.onAddIngredients, // Required callback for adding new ingredients.
    required this.onCamera,  // Required callback for opening the camera page.
    required this.client,
  });


  static const String routeName = '/edit_meal_form_page'; // Route name for navigation to this page.

  @override
  Widget build(BuildContext context) {
    // List<Ingredient> ingredients = <Ingredient>[ // The list containing the ingredients of the meal.
    //   Ingredient(name: "Knækbrød"),   /// TEST ///
    //   Ingredient(name: "Æble"),       /// TEST ///
    // ];

    return Scaffold( // Scaffold provides the basic visual structure for the page.
      appBar: AppBar( // AppBar at the top of the page.
        title: const Text("Rediger madpakke"), // Title of the AppBar.
        centerTitle: true, // Center the title.
        backgroundColor: AppColors.background, // Background color for the AppBar.
        elevation: 1.0, // Shadows beneath the AppBar.
        iconTheme: const IconThemeData(color: AppColors.textPrimary),  // Icon color in the AppBar.
        titleTextStyle: const TextStyle( // Text style for the title.
          color: AppColors.textPrimary,  // Color for the title text.
          fontSize: 18, // Font size of the title.
          fontWeight: FontWeight.bold, // Bold font weight for the title.
        ),
      ),

      body: _buildEditMealPage(context, ingredients ?? []) // Build the edit meal page with the ingredients.
    );
  }
  
  // Helper method to build the Edit Meal Page after ingredients are fetched
  Widget _buildEditMealPage(BuildContext context, List<Ingredient> ingredients) {
    return Padding( // Padding applied around the content inside the column.
      padding: EdgeInsets.only(top: 5, left: 16, right: 16, bottom: 12), // Define the padding in all directions.
      child: Column( // Vertical layout for the page.
        children: [
          // The list of elements which are created for each of the ingredients.
          Expanded( // Expanded widget to fill available space.
            child: ListView.separated( // Creates a scrollable list with separators.
              itemCount: ingredients.length, // Creates an element for each ingredient.
              itemBuilder: (BuildContext context, int index) { // Builds the list items for each ingredient.
                return EditMealElement(meal: meal, onCamera: onCamera,); // Render each ingredient element.
              },
              separatorBuilder: (BuildContext context, int index) { // Defines the separator between list items.
                return SizedBox(height: 20,); // Space between elements.
              },
            ),
          ),
          
          // The button for adding a new ingredient to the meal.
          CustomElevatedButton(
            onTab: () { // Leads to the "add_ingredient_page"
              onAddIngredients(); // Calls the callback to change to the "add_ingredient_page".
            },
            widget: Icon(Icons.add, color: AppColors.textSecondary),  // Icon displayed on the button.
            backgroundColor: AppColors.tertiary, // Background color of the button.
            width: MediaQuery.sizeOf(context).width/2, // Half the width of the screen for the button.
          ),

          // The button for saving the changes made to meal.
          CustomElevatedButton(
            onTab: () {
              updateMeal(client, meal);
              context.pop(); // Goes back to the previous page.
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