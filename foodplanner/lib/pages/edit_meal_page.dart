import 'package:flutter/material.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/cameraPage.dart';
import 'package:foodplanner/pages/edit_meal_form_page.dart';

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
      _pages.addAll([
        EditMealFormPage(
          meal: meal,
          onAddIngredients: () {_changePageIndex(1);},
          onCamera: () {_changePageIndex(2);},
        ),
        AddIngredientPage(
          meal: meal,
          onCamera: () {_changePageIndex(2);},
        ),
        CameraPage(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPageIndex],
    );
  }
}