import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/pages/edit_meal_form_page.dart';
import 'package:foodplanner/services/fetch_user_data.dart';
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
  List<Ingredient> ingredients = [];  // List to store ingredients associated with the meal.
  Meal meal = Meal();  // Meal object being edited.
  int currentPageIndex = 0; // Index to track the currently displayed page.
  Client? _client; // Client for the requests to the server

  // Changes the current page index and updates the UI.
  void _changePageIndex(int index) {
    setState(() {
      currentPageIndex = index; // Updates the current page index.
    });
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
    final auth = AuthProvider(); // Create an instance of AuthProvider to get user authentication.
    // Fetch user's ingredients by decoding the JWT token.
    ingredients = await fetchIngredientsByUserID(_client!, FetchUserData.decodeUserIDFromJWT(auth.jwtToken!));

    setState(() { // Update the state of the widget.
      _pages = [ // Assign the fetched meal and ingredients to the list of pages.
        EditMealFormPage(
          meal: meal, // Pass the meal object to the EditMealFormPage.
          ingredients: ingredients, // Pass the ingredients to the EditMealFormPage.
          client: _client!,
          onAddIngredients: () {
            _changePageIndex(1); // Changes the shown page to "add_ingredent_page.dart" when executed.
          },
          onCamera: () {
            _changePageIndex(2); // Changes the shown page to "camera_page.dart" when executed.
          },
        ),
        AddIngredientPage(
          meal: meal,  // Pass the meal object to the AddIngredientPage.
          ingredients: ingredients, // Pass the ingredients to the AddIngredientPage.
          client: _client!,
          onCamera: () {
            _changePageIndex(2); // Changes the shown page to "camera_page.dart" when executed.
          },
          onIngredientsUpdated: (newIngredients) { // Update ingredients when modified.
          setState(() {
            ingredients = newIngredients;
          });
        },
        ),
        CameraPage(client: _client!,), // Instantiates the CameraPage.
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
    if (_pages.isEmpty) { // Checks if the pages list is empty.
      return Scaffold(body: Center(child: CircularProgressIndicator())); // If it is, it shows a loading circle.
    }
    return Scaffold(
      body: _pages[currentPageIndex], // Displays the currently selected page based on the currentPageIndex.
    );
  }
}