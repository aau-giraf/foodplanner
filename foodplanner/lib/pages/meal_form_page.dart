import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:http/http.dart';

/// This class is used to create the meal page where the user can create an individual meal for their children.
class MealFormPage extends StatefulWidget {
  final Meal meal; // The meal being created or edited.
  final List<Ingredient>? ingredients; // The list of ingredients available.
  final VoidCallback onAddIngredients; // Callback for adding ingredients.
  final VoidCallback onCamera; // Callback for opening the camera.
  final Client client;
  
  const MealFormPage({
    super.key, // Key for the widget, maintaining state.
    required this.meal, // Required parameter for the meal.
    required this.ingredients, // Required parameter for the ingredients.
    required this.onAddIngredients, // Callback for adding ingredients.
    required this.onCamera, // Callback for accessing the camera.
    required this.client,
  });

  static const String routeName = '/meal_form_page'; // Route name for navigation.

  @override
  _MealFormPageState createState() => _MealFormPageState(); // Create the state for this page.
}



class _MealFormPageState extends State<MealFormPage> {
  final TextEditingController _titleController = TextEditingController();  // Controller for the title text field.
  Image? _selectedImage; // Variable to hold the selected image.

  // Method for deleting the controllers when they are done being used.
  @override
  void dispose() {
    _titleController.dispose(); // Dispose of the title controller to free up resources.
    super.dispose(); // Call the superclass dispose method.
  }

  @override
  Widget build(BuildContext context) {
    int maxTextLength = 20; // The max number of characters that can be inputted into the textfield.
    // final List<Ingredient> selectedIngredients = [];
    // selectedIngredients.addAll(
    //   widget.ingredients.where((ingredient) {
    //     return widget.meal.getPackedIngredients.map(
    //       (packedIngredient) => packedIngredient.ingredientRef.id).contains(ingredient.id);
    //     }
    //   ),
    // );

    return Scaffold( // Scaffold to set the layout structure for the page.
      appBar: AppBar( // AppBar at the top of the page.
        title: const Text("Opret madpakke"), // Title of the AppBar.
        centerTitle: true, // Center the title in the AppBar.
        backgroundColor: AppColors.background, // Background color for the AppBar.
        elevation: 1.0, // Shadow effect for the AppBar.
        iconTheme: const IconThemeData(color: AppColors.textPrimary), // Icon color in the AppBar.
        titleTextStyle: const TextStyle( // Text style for the title.
          color: AppColors.textPrimary, // Color for the title text.
          fontSize: 18, // Font size for the title.
          fontWeight: FontWeight.bold, // Bold font weight for the title.
        ),
      ),

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
                controller: _titleController, // Controller for managing the inputted text.
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
              backgroundColor: AppColors.secondary, // Background color of the button.
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
                        onPressed: () { // Leads the user to the camera page. 
                          widget.onCamera(); // Calls the camera callback.
                        },
                        child: const Text("Ja"), // Button text for "Yes".
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true, // Mark as a destructive action.
                        onPressed: () {
                          createMeal( // Creates a meal using the inputted ingredients, without an image.
                            widget.client,
                            _titleController.text, // Title from the text input.
                            null,  // No image provided.
                            DateTime.now(),  // Current date and time for the meal.
                            widget.meal.getPackedIngredients, // Retrieve packed ingredients for the meal.
                          );
                          context.go(MEAL_LIST_PAGE); // Leads the user to the meal list page.
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
