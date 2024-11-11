import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/pages/edit_meal_form_page.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// This is used to manage the page shifting between "edit_meal_form_page.dart", "add_ingredient_page.dart", and "camera_page.dart".
class EditMealPage extends StatefulWidget {
  final int mealID; // Meal ID needed for editing the specific meal.

  const EditMealPage({
    super.key, // Key for the widget, used for maintaining state.
    required this.mealID, // Required meal ID parameter.
  });

  static const String routeName = '/edit_meal_page'; // Route name for navigation to this page.

  @override
  State<EditMealPage> createState() => _EditMealPageState(); // Creates the state object for this widget.
}

class _EditMealPageState extends State<EditMealPage> {
  Meal meal = Meal();  // Meal object being edited.
  List<Ingredient> ingredients = []; // List to store all the users ingredient presets.
  List<int> pageStack = [0]; // Page stack to track the currently displayed page and the previous pages.
  File? image;
  Client? _client; // Client for the requests to the server

  void _pushPage(int index) { // Push a new page onto the stack
    setState(() {
      pageStack.add(index);
    });
  }

  void _popPage() { // Pop the top page from the stack to go back
    if (pageStack.length > 1) {
      setState(() {
        pageStack.removeLast();
      });
    }
  }

  List<Widget> _pages = []; // List to hold the different pages for editing the meal.

  @override
  void initState() {
    super.initState(); // Call the superclass's initState method.
    _client = http.Client(); // Set the client for the system
    _initializePage(); // Initialize the page to fetch the meal and ingredients.
  }

  // Asynchronously initializes the page with meal data and user ingredients.
  Future<void> _initializePage() async {
    meal = await fetchMeal(_client!, widget.mealID); // Fetch the meal details using the mealID.
    // Fetch user's ingredients by decoding the JWT token.
    ingredients = await fetchIngredientsByUserID(_client!);

    setState(() { // Update the state of the widget.
      _pages = [ // Assign the fetched meal and ingredients to the list of pages.
        EditMealFormPage(
          meal: meal, // Pass the meal object to the EditMealFormPage.
          ingredients: ingredients, // Pass the ingredients to the EditMealFormPage.
          client: _client!,
          onAddIngredients: () {
            _pushPage(1); // Changes the shown page to "add_ingredent_page.dart" when executed.
          },
          onCamera: () {
            _pushPage(2); // Changes the shown page to "camera_page.dart" when executed.
          },
        ),
        AddIngredientPage(
          ingredients: ingredients, // Pass the ingredients to the AddIngredientPage.
          image: image,
          client: _client!,
          onCamera: () {
            _pushPage(2); // Changes the shown page to "camera_page.dart" when executed.
          },
          onIngredientsUpdated: (newIngredients) { // Update ingredients when modified.
            setState(() {
              ingredients = newIngredients;
            });
          },
          onIngredientAdded: (addedIngredient) {
            meal.ingredients.add(addedIngredient);
            _popPage();
          } // Go back to the previous page after adding new ingredient.
        ),
        CameraPage(
          client: _client!,
          onImagePicked: (image) {
          setState(() {
            if(image is File) this.image = image;
          });
        },
        ), // Instantiates the CameraPage.
      ];
    });
  }

  @override
  void dispose() {
    _client?.close(); // Close the client when the page is closed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: pageStack.length > 1 // Show back button if there's a previous page
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: _popPage,
            )
          : null, // No back button on the first page
        title: const Text("Rediger madpakke"), // Title of the AppBar.
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
      body: _pages.isNotEmpty
        ? _pages[pageStack.last] // Show the page at the top of the stack
        : Center(child: CircularProgressIndicator()), // Show loading spinner if _pages is empty
    );
  }
}