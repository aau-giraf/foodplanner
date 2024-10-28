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

/// This class is used to create the page for editing an already existing meal.
class EditMealPage extends StatefulWidget {
  final int mealID;

  const EditMealPage({
    super.key,
    required this.mealID,
  });

  static const String routeName = '/edit_meal_page';

  @override
  State<EditMealPage> createState() => _EditMealPageState();
}

class _EditMealPageState extends State<EditMealPage> {
  List<Ingredient> ingredients = [];
  Meal meal = Meal();
  int currentPageIndex = 0;

  void _changePageIndex(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  Future<void> _initializePage() async {
    meal = await fetchMeal(widget.mealID);
    final auth = AuthProvider();
    ingredients = await fetchIngredientsByUserID(FetchUserData.decodeUserIDFromJWT(auth.jwtToken!));

    setState(() {
      _pages = [
        EditMealFormPage(
          meal: meal,
          ingredients: ingredients,
          onAddIngredients: () {
            _changePageIndex(1);
          },
          onCamera: () {
            _changePageIndex(2);
          },
        ),
        AddIngredientPage(
          meal: meal,
          ingredients: ingredients,
          onCamera: () {
            _changePageIndex(2);
          },
        ),
        CameraPage(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pages.isEmpty) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: _pages[currentPageIndex],
    );
  }
}