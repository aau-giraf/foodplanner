import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/cameraPage.dart';
import 'package:foodplanner/pages/edit_meal_form_page.dart';
import 'package:foodplanner/services/fetch_user_data.dart';

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

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();

    fetchMeal(widget.mealID).then((meal) {
      this.meal = meal;
    });
    final auth = AuthProvider();
    fetchIngredientsByUserID(FetchUserData.decodeUserIDFromJWT(auth.jwtToken!)).then((ingredients) {
      this.ingredients = ingredients;
    });
    
    _pages.addAll([
      EditMealFormPage(
        meal: meal,
        ingredients: ingredients,
        onAddIngredients: () {_changePageIndex(1);},
        onCamera: () {_changePageIndex(2);},
      ),
      AddIngredientPage(
        meal: meal,
        ingredients: ingredients,
        onCamera: () {_changePageIndex(2);},
      ),
      CameraPage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],
    );
  }
}