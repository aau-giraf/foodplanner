import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';

class PackedIngredient {
  final Meal mealRef;
  Ingredient ingredientRef;
  final int id;

  PackedIngredient({
    this.mealRef = const Meal(),
    this.ingredientRef = const Ingredient(),
    this.id = 0,
  });

  void set setIngredientRef(Ingredient _ingredientRef) {
    ingredientRef = _ingredientRef;
  }

  factory PackedIngredient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'mealRef': Meal mealRef,
        'ingredientRef': Ingredient ingredientRef,
        'id': int id,
      } =>
        PackedIngredient(
            mealRef: mealRef,
            ingredientRef: ingredientRef,
            id: id,
        ),
      _ => throw const FormatException('Ingrediens kunne ikke findes.'),
    };
  }
}