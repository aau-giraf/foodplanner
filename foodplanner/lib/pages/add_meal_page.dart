import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/fetch_user_data.dart';
import 'package:foodplanner/pages/meal_form_page.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// This is used to manage the page shifting between "meal_form_page.dart", "add_ingredient_page.dart", and "camera_page.dart".
class AddMealPage extends StatefulWidget {
  final Meal meal; // The meal object to be managed within this page.

  const AddMealPage({
    super.key, // Key for the widget, used for maintaining state.
    this.meal = const Meal(), // Optional Meal object, defaults to a new Meal instance if none is provided.
  });

  static const String routeName = '/add_meal_page'; // Route name for navigation.

  @override
  State<AddMealPage> createState() => _AddMealPageState(); // Creates the state for this widget.

}

class _AddMealPageState extends State<AddMealPage> {
  List<Ingredient> ingredients = []; // List to store ingredients associated with the meal.
  int currentPageIndex = 0; // Index to track the currently displayed page.
  Client? _client; // Client for the requests to the server

  // Changes the current page index and updates the UI.
  void _changePageIndex(int index) {
    setState(() {
      currentPageIndex = index; // Updates the current page index.
    });
  }

  final List<Widget> _pages = []; // List to hold the different pages.

  @override
  void initState() { 
    super.initState(); // Call the superclass's initState method.
    _client = http.Client(); // Set the client for the system
    final auth = AuthProvider(); // Create an instance of AuthProvider to access authentication data.
    
    if (auth.jwtToken == null) { // If no user is found reroute to the login page.
      context.go(LOGIN_PAGE);
      return;
    }

    fetchIngredientsByUserID(_client!, FetchUserData.decodeUserIDFromJWT(auth.jwtToken!)).then((fetchedIngredients) {
      setState(() {
        ingredients = fetchedIngredients; // Assign the fetched ingredients to the state variable.
        _initializePages(); // Initialize pages after fetching ingredients.
      });
    });
  }

  void _initializePages() {
    _pages.addAll([ // Adds all of the pages to the "_pages" list
      MealFormPage( // The MealFormPage is the first page to be displayed.
        meal: widget.meal, // Pass the meal to the MealFormPage.
        ingredients: ingredients, // Pass the ingredients to the MealFormPage.
        client: _client!,
        onAddIngredients: () => _changePageIndex(1), // Changes the shown page to "add_ingredent_page.dart" when executed.
        onCamera: () => _changePageIndex(2), // Changes the shown page to "camera_page.dart" when executed.
      ),
      AddIngredientPage( // The AddIngredientPage is the second page.
        meal: widget.meal, // Pass the meal to the AddIngredientPage.
        ingredients: ingredients, // Pass the ingredients to the AddIngredientPage.
        client: _client!,
        onCamera: () => _changePageIndex(2), // Changes the shown page to "camera_page.dart" when executed.
        onIngredientsUpdated: (newIngredients) { // Update ingredients when modified.
          setState(() {
            ingredients = newIngredients;
          });
        },
      ),
      CameraPage(client: _client!,), // The CameraPage is the third page.
    ]);
  }

  @override
  void dispose() {
    _client?.close(); // Close the client when the page is closed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Main structure of the page.
      body: _pages[currentPageIndex],  // Display the currently selected page based on the currentPageIndex.
    );
  }
}