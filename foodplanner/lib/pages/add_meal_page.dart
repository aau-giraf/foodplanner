import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/cameraPage.dart';
import 'package:foodplanner/pages/meal_form_page.dart';

class AddMealPage extends StatefulWidget {
  final Meal meal;

  const AddMealPage({
    super.key,
    required this.meal,
  });

  static const String routeName = '/add_meal_page';

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
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
    _pages.addAll([
      MealFormPage(
        onAddIngredients: () => _changePageIndex(1),
        onCamera: () => _changePageIndex(2),
      ),
      AddIngredientPage(mealID: widget.meal.id),
      CameraPage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[
          currentPageIndex],
    );
  }
}