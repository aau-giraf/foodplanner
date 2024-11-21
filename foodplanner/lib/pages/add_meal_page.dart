import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:foodplanner/services/food_image_service.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:foodplanner/services/meal_services.dart';
import 'package:foodplanner/services/packed_ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';

/// This is used to manage the page shifting between "meal_form_page.dart", "add_ingredient_page.dart", and "camera_page.dart".
class AddMealPage extends StatefulWidget {
  final Future<List<Ingredient>> Function(Client client, AuthProvider auth)
      fetchFunction;

  const AddMealPage({
    super.key, // Key for the widget, used for maintaining state.
    this.fetchFunction = fetchIngredientsByUserID,
  });

  @override
  State<AddMealPage> createState() =>
      AddMealPageState(); // Creates the state for this widget.
}

class AddMealPageState extends State<AddMealPage> {
  List<Ingredient> ingredients =
      []; // List to store all the users ingredient presets.
  String mealTitle = '';
  late TextEditingController mealTitleController;
  List<PackedIngredient> packedIngredients =
      []; // List to store all ingredients added to the meal.
  http.MultipartFile? image;
  List<int> pageStack = [
    0
  ]; // Page stack to track the currently displayed page and the previous pages.
  Client? _client; // Client for the requests to the server
  Completer<void>? cameraPageCompleter;

  void pushPage(int index) {
    // Push a new page onto the stack
    setState(() {
      pageStack.add(index);
    });
  }

  Future<void> popPage() async {
    // Pop the top page from the stack to go back
    if (pageStack.length > 1) {
      setState(() {
        pageStack.removeLast();
      });
    }

    cameraPageCompleter?.complete();
    cameraPageCompleter = null;
  }

  List<Widget> _pages = []; // List to hold the different pages.

  Future<void> onCreateMeal(http.Client client, String title) async {
    final authProvider = AuthProvider();
    final mealNotifier = MealNotifier();
    int? imageId = this.image != null
        ? int.parse((await UploadFoodImage(
                // openapi.ApiClient(),
                http.Client(),
                this.image!))
            .body)
        : null;

    print(
        "her: ${DateFormat('yyyy-MM-dd').format(await mealNotifier.retrieveDate())}");

    await createMeal(
      // Creates a meal using the inputted ingredients, without an image.
      client,
      authProvider,
      title, // Title from the text input.
      imageId,
      await mealNotifier.retrieveDate(),
    ).then((response) {
      final storedMeal =
          Meal.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      packedIngredients.forEach((packedIngredient) async {
        await createPackedIngredient(
          client,
          authProvider,
          storedMeal.id,
          packedIngredient.ingredient.id,
        );
      });
    });
  }

  @override
  void initState() {
    super.initState(); // Call the superclass's initState method.
    _client = http.Client(); // Set the client for the system
    mealTitleController = TextEditingController(text: mealTitle);
    final auth =
        AuthProvider(); // Create an instance of AuthProvider to access authentication data.

    // if (auth.jwtToken == null) { // If no user is found reroute to the login page.
    //   context.go(LOGIN_PAGE);
    //   return;
    // }

    widget.fetchFunction(_client!, auth).then((fetchedIngredients) {
      setState(() {
        ingredients =
            fetchedIngredients; // Assign the fetched ingredients to the state variable.
        _initializePages(); // Initialize pages after fetching ingredients.
      });
    });
  }

  void _initializePages() {
    _pages.addAll([
      // Adds all of the pages to the "_pages" list
      MealFormPage(
        // The MealFormPage is the first page to be displayed.
        ingredients: ingredients, // Pass the ingredients to the MealFormPage.
        packedIngredients:
            packedIngredients, // Pass the meal to the MealFormPage.
        mealTitleController: mealTitleController,
        image: image,
        client: _client!,
        onAddIngredients: () => pushPage(
            1), // Changes the shown page to "add_ingredent_page.dart" when executed.
        onCamera: () async {
          cameraPageCompleter = Completer<void>();
          pushPage(2);
          await cameraPageCompleter!.future;
        }, // Changes the shown page to "camera_page.dart" when executed.
        onCreateMeal: (client, title) => onCreateMeal(client, title),
      ),
      AddIngredientPage(
          // The AddIngredientPage is the second page.
          ingredients:
              ingredients, // Pass the ingredients to the AddIngredientPage.
          image: image,
          client: _client!,
          onCamera: () => pushPage(
              2), // Changes the shown page to "camera_page.dart" when executed.
          onIngredientsUpdated: (newIngredients) {
            // Update ingredients when modified.
            setState(() {
              ingredients = newIngredients;
            });
          },
          onIngredientAdded: (addedIngredient) {
            packedIngredients.add(addedIngredient as PackedIngredient);
            popPage();
          } // Go back to the previous page after adding new ingredient.
          ),
      CameraPage(
        onImagePicked: (image) {
          setState(() {
            if (image is http.MultipartFile) {
              this.image = image;
            }
          });
          popPage();
        },
      ), // The CameraPage is the third page.
    ]);
  }

  @override
  void dispose() {
    _client?.close(); // Close the client when the page is closed.
    mealTitleController
        .dispose(); // Dispose of the title controller to free up resources.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main structure of the page.
      appBar: AppBar(
        leading:
            pageStack.length > 1 // Show back button if there's a previous page
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: popPage,
                  )
                : null, // No back button on the first page
        title: const Text("Opret madpakke"), // Title of the AppBar.
        centerTitle: true, // Center the title in the AppBar.
        backgroundColor:
            AppColors.background, // Background color for the AppBar.
        elevation: 1.0, // Shadow effect for the AppBar.
        iconTheme: const IconThemeData(
            color: AppColors.textPrimary), // Icon color in the AppBar.
        titleTextStyle: const TextStyle(
          // Text style for the title.
          color: AppColors.textPrimary, // Color for the title text.
          fontSize: 18, // Font size for the title.
          fontWeight: FontWeight.bold, // Bold font weight for the title.
        ),
      ),
      body: _pages.isNotEmpty
          ? _pages[pageStack.last] // Show the page at the top of the stack
          : Center(
              child:
                  CircularProgressIndicator()), // Show loading spinner if _pages is empty
    );
  }
}
