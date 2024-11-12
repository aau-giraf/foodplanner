import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/services/food_image_service.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:foodplanner/services/packed_ingredient_services.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

/// This class is used to create the meal page where the user can create an individual meal for their children.
class MealFormPage extends StatefulWidget {
  final List<Ingredient>? ingredients; // The list of ingredients available.
  final List<PackedIngredient> packedIngredients; // The meal being created or edited.
  final TextEditingController mealTitleController;
  final File? image;
  final VoidCallback onAddIngredients; // Callback for adding ingredients.
  final AsyncCallback onCamera; // Callback for opening the camera.
  final Client client;
  
  const MealFormPage({
    super.key, // Key for the widget, maintaining state.
    required this.ingredients, // Required parameter for the ingredients.
    required this.packedIngredients, // Required parameter for the meal.
    required this.mealTitleController,
    required this.image,
    required this.onAddIngredients, // Callback for adding ingredients.
    required this.onCamera, // Callback for accessing the camera.
    required this.client,
  });

  static const String routeName = '/meal_form_page'; // Route name for navigation.

  @override
  _MealFormPageState createState() => _MealFormPageState(); // Create the state for this page.
}



class _MealFormPageState extends State<MealFormPage> {
  // Method for deleting the controllers when they are done being used.
  @override
  void dispose() {
    super.dispose(); // Call the superclass dispose method.
  }

  void onCreateMeal() async {
  final authProvider = AuthProvider();
  int? imageId = widget.image != null ? 
    (jsonDecode(
      (await UploadFoodImage(
        widget.client,
        authProvider,
        widget.image!
      )).body
    ) as Map<String, dynamic>)['id'] as int? : null;
  await createMeal( // Creates a meal using the inputted ingredients, without an image.
    widget.client,
    authProvider,
    widget.mealTitleController.text, // Title from the text input.
    imageId,
    DateTime.now(),  // Current date and time for the meal.
  ).then((response) {
    final storedMeal = Meal.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    widget.packedIngredients.forEach((packedIngredient) async {
      await createPackedIngredient(
        widget.client,
        authProvider,
        storedMeal.id,
        packedIngredient.ingredientRef.id,
      );
    });
  });
  }

  @override
  Widget build(BuildContext context) {
    int maxTextLength = 20; // The max number of characters that can be inputted into the textfield.

    return Scaffold( // Scaffold to set the layout structure for the page.
      body: Padding( // Padding around the body content.
        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 16.0, left: 16.0), // Specify padding values.
        child: Column( // Vertical layout for the content.
          children: [ // Textfield for the title of the meal.
            Text(
              'Start med at give madpakken en titel', // Hint text for title input.
              style: TextStyle(color: AppColors.textFieldHint), // Style for hint text.
            ),
            Container(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),  // Padding for the text field container.
              child: TextField( // Text field for entering the meal title.
                controller: widget.mealTitleController, // Controller for managing the inputted text.
                maxLength: maxTextLength, // Maximum length of characters allowed.
                inputFormatters: <TextInputFormatter>[ // Input formatters to restrict input.
                  FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
                ], // Only alphanumeric characters can be entered
                decoration: InputDecoration( // Input decoration for the text
                  counterText: '', // No counter text shown for the character limit.
                  hintText: 'Skriv her...', // Placeholder text for the text filed.
                  hintStyle: TextStyle(
                    color: AppColors.textFieldHint, // Style for the hint text color.
                  ),
                  // border: UnderlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 50), // Spacer for vertical layout.

            // Add Ingredient button
            Text(
              'Tilføj ingredienser', // Header for the ingredients section.
              style: TextStyle(color: AppColors.textFieldHint),  // Style for the ingredients text.
            ),
            CustomElevatedButton( // Custom button for adding ingredients.
              onTab: () {
                // context.go(ADD_INGREDIENT_PAGE);
                widget.onAddIngredients(); // Calls the callback to add 
              },
              widget: Icon(Icons.add, color: AppColors.textSecondary), // Icon displayed on the button.
              backgroundColor: AppColors.tertiary, // Background color of the button.
              width: MediaQuery.sizeOf(context).width/2, // Width of the button is half of the screen width.
            ),
            Spacer(), // Flexible space to push the next button down.

            // Create meal button
            CustomElevatedButton(
              onTab: () {
                showCupertinoDialog( // If not, it opens a pop-up window.
                  context: context, 
                  builder: (BuildContext context) => CupertinoAlertDialog( // Create a Cupertino alert dialog.
                    title: Text('Vil du tilføje et billede af madpakken?  '), // Title of the dialog.
                    actions: <CupertinoDialogAction>[ // Actions for the alert dialog.
                      CupertinoDialogAction(
                        isDefaultAction: true, // Highlight the default action.
                        onPressed: () async { // Leads the user to the camera page. 
                          Navigator.pop(context);
                          await widget.onCamera(); // Calls the camera callback.
                          onCreateMeal();
                          //context.pop();
                        },
                        child: const Text("Ja"), // Button text for "Yes".
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true, // Mark as a destructive action.
                        onPressed: () async {
                          Navigator.pop(context);
                          onCreateMeal();
                          //context.pop();
                        },
                        child: const Text('Nej'),  // Button text for "No".
                      ),
                    ],
                  ),
                );
              },
              width: MediaQuery.sizeOf(context).width/2, // Width of the button is half of the screen width.
              widget: const Text(
                'Opret madpakke', // Text displayed on the button for creating the meal.
                style: AppTextStyles.buttonText, // Text style for the button.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
