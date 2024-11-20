import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:http/http.dart';

/// This class is used for selecting which ingredients should be added to the meal.
class AddIngredientPage extends StatefulWidget {
  final List<Ingredient> ingredients; // List of available ingredients for selection.
  final MultipartFile? image;
  final ValueChanged<List<Ingredient>> onIngredientsUpdated; // Callback to the method which modifies the list of existing ingredients
  final VoidCallback onCamera; // Callback to change the shown page through "add_meal_page.dart"
  final VoidCallback onCreateIngredient;
  final ValueSetter onIngredientAdded; // Callback to handle what to do once a new ingredient is added.
  final Client client;

  const AddIngredientPage({
    super.key,
    required this.ingredients, // Required list of Ingredient objects to pass.
    required this.image,
    required this.onIngredientsUpdated, // Required callback to handle the ingredient list updating.
    required this.onCamera, // Required callback to handle camera navigation.
    required this.onCreateIngredient,
    required this.onIngredientAdded, // Required callback to handle navigation after a new ingredient is added.
    required this.client,
  });

  @override
  _AddIngredientPageState createState() => _AddIngredientPageState(); // Create state for the page.
}

class _AddIngredientPageState extends State<AddIngredientPage> {
  TextEditingController _searchBarController = TextEditingController(); // Controller for the search bar.
  List<Ingredient> sortedIngredients = []; // List to hold the filtered ingredients.

  @override
  void initState() {
    super.initState(); // Call the superclass's initState method.
    // Initialize the sorted ingredients with all available ingredients.
    sortedIngredients = widget.ingredients;
  }

  @override
  void dispose() {
    _searchBarController.dispose(); // Dispose of the text controller to free up resources.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // The main body of the AddIngredientPage.
      body: _buildAddIngredientPage(context, sortedIngredients)
    );
  }

  Widget _buildAddIngredientPage(BuildContext context, List<Ingredient> ingredients) {
    // List<Ingredient> sortedIngredients = ingredients;
    int maxTextLength = 20; // The max number of characters that can be inputted into the textfield.

    return Column(
      children: [
        // The search field for the user to search for specific ingredients.
        Padding(
          padding: EdgeInsets.only(top: 5, right: 16, left: 16), // Adding padding around the search bar.
          child: TextField(
            controller: _searchBarController, // Connect the controller to the text field.
            maxLength: maxTextLength, // Set the maximum length for the input.
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z +-]")),
            ], // Only alphanumeric characters can be entered
            decoration: InputDecoration(
              counterText: '', // Hides the character counter.
              border: InputBorder.none, // Removes the default border.
              hintText: 'Skriv her...', // Placeholder text.
              hintStyle: TextStyle(
                color: AppColors.textFieldHint, // Hint text color.
              ),
              filled: true, // Enables filling the background of the text field.
              fillColor: AppColors.textFieldBackground, // Background color of text field.
            ),
            onChanged: (text) { // Updates the list when changes in the search field happen.
              setState(() {
                sortedIngredients = widget.ingredients.where((ingredient) {
                  return ingredient.name.toLowerCase().contains(text.toLowerCase()); // Filter ingredients by name.
                }).toList();
              });
            },
          ),
        ),

        Divider(color: AppColors.textFieldBorder,), // Divider below the search bar.

        // The list of available ingredients.
        Expanded( // Allows the list of ingredients to take remaining available space.
          child: ListView.separated( // Creates a list view with separators between items.
            itemCount: sortedIngredients.length,  // Number of items in the soreted ingredient list.
            itemBuilder: (BuildContext context, int index) { // Builds each item in the list.
              return TextButton(  // A button for each ingredient.
                onPressed: () {  // Action when the button is pressed.
                  if (sortedIngredients[index].imageRef == null) { // Checks if the ingredient has an image.
                    showCupertinoDialog( // If not, it opens a pop-up window.
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog( // Build the dialog.
                        title: Text('Der er ikke et billede til denne ingrediens, tilføj dette nu.'), // Title of the dialog.
                        actions: <CupertinoDialogAction>[ // Actions in the dialog.
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () async { // Leads the user to the camera page.
                              Navigator.pop(context);
                              // Navigate to camera page
                              widget.onCamera(); // Calls the passed callback to navigate to the camera page.
                            },
                            child: const Text("OK"), // Button text.
                          ),
                        ],
                      ),
                    );
                  }
                  final newPacked = PackedIngredient(
                    ingredientRef: sortedIngredients[index],
                  );
                  widget.onIngredientAdded(newPacked);
                },
                style: TextButton.styleFrom( // Styling the button.
                  shape: RoundedRectangleBorder( // Shape of the button.
                    borderRadius: BorderRadius.zero, // Set corner radius to zero.
                  )
                ), 
                child: Align(  // Aligns the child within the button.
                  alignment: Alignment.centerLeft,  // Aligns text to the left.
                  child: Text(sortedIngredients[index].name, style: AppTextStyles.standard),  // Displays the ingredient name with specified text style.
                )
              );
            }, 
            separatorBuilder: (BuildContext context, int index) { // Builds a separator between items.
              return Divider(color: AppColors.textFieldBorder,); // Divider line between list items.
            },
          )
        ),
        Divider(color: AppColors.textFieldBorder,), // Final divider at the bottom of the list.
        CustomElevatedButton( // "+" button for leading the user to the create ingredient page.
          onTab: () {
            widget.onCreateIngredient();
          },
          widget: Icon(Icons.add, color: AppColors.textSecondary), // Icon displayed on the button.
          backgroundColor: AppColors.tertiary, // Background color of the button.
          width: MediaQuery.sizeOf(context).width/2, // Width of the button is half of the screen width.
        ),
        Spacer(),
      ],
    );
  }
}