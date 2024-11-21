import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
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
  final Future<List<Ingredient>> Function(Client client, AuthProvider auth) fetchIngredientsFunction;
  final Future<Meal> Function(Client client, AuthProvider auth, int mealId) fetchMealFunction;

  const EditMealPage({
    super.key, // Key for the widget, used for maintaining state.
    required this.mealID, // Required meal ID parameter.
    this.fetchIngredientsFunction = fetchIngredientsByUserID,
    this.fetchMealFunction = fetchMeal,
  });

  @override
  State<EditMealPage> createState() => EditMealPageState(); // Creates the state object for this widget.
}

class EditMealPageState extends State<EditMealPage> {
  Meal meal = Meal();  // Meal object being edited.
  List<PackedIngredient> packedIngredients = [];
  List<Ingredient> ingredients = []; // List to store all the users ingredient presets.
  List<int> pageStack = [0]; // Page stack to track the currently displayed page and the previous pages.
  MultipartFile? image;
  Client? _client; // Client for the requests to the server

  void pushPage(int index) { // Push a new page onto the stack
    setState(() {
      pageStack.add(index);
    });
  }

  void popPage() { // Pop the top page from the stack to go back
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
    final authProvier = AuthProvider();
    meal = await widget.fetchMealFunction(_client!, authProvier, widget.mealID); // Fetch the meal details using the mealID.
    packedIngredients = meal.ingredients;
    // Fetch user's ingredients by decoding the JWT token.
    ingredients = await widget.fetchIngredientsFunction(_client!, authProvier);

    setState(() { // Update the state of the widget.
      _pages = [ // Assign the fetched meal and ingredients to the list of pages.
        EditMealFormPage(
          meal: meal, // Pass the meal object to the EditMealFormPage.
          packedIngredients: packedIngredients,
          ingredients: ingredients, // Pass the ingredients to the EditMealFormPage.
          client: _client!,
          onAddIngredients: () {
            pushPage(1); // Changes the shown page to "add_ingredent_page.dart" when executed.
          },
          onCamera: () {
            pushPage(2); // Changes the shown page to "camera_page.dart" when executed.
          },
          image: image,
        ),
        AddIngredientPage(
          ingredients: ingredients, // Pass the ingredients to the AddIngredientPage.
          image: image,
          client: _client!,
          onCamera: () {
            pushPage(2); // Changes the shown page to "camera_page.dart" when executed.
          },
          onIngredientsUpdated: (newIngredients) { // Update ingredients when modified.
            setState(() {
              ingredients = newIngredients;
            });
          },
          onIngredientAdded: (addedIngredient) {
            packedIngredients.add(addedIngredient);
            popPage();
          } // Go back to the previous page after adding new ingredient.
        ),
        CameraPage(
          onImagePicked: (image) {
          setState(() {
            if(image is MultipartFile) this.image = image;
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
              onPressed: popPage,
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