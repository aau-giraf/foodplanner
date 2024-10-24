import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/cameraPage.dart';
import 'package:foodplanner/services/fetch_user_data.dart';
import 'package:foodplanner/pages/meal_form_page.dart';

class AddMealPage extends StatefulWidget {
  final Meal meal;

  const AddMealPage({
    super.key,
    this.meal = const Meal(),
  });

  static const String routeName = '/add_meal_page';

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  List<Ingredient> ingredients = [];
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
    final auth = AuthProvider();
    fetchIngredientsByUserID(FetchUserData.decodeUserIDFromJWT(auth.jwtToken!)).then((ingredients) {
      this.ingredients = ingredients;
    });
    _pages.addAll([
      MealFormPage(
        meal: widget.meal,
        ingredients: ingredients,
        onAddIngredients: () {_changePageIndex(1);},
        onCamera: () {_changePageIndex(2);},
      ),
      AddIngredientPage(
        meal: widget.meal,
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