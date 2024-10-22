import 'dart:convert';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:http/http.dart' as http;

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

Future<Ingredient> fetchPackedIngredient(int id) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/$id'));

  if (response.statusCode == 200) {
    return Ingredient.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Kunne ikke hente ingrediens');
  }
}

Future<http.Response> createPackedIngredient(Meal mealRef, Ingredient ingredientRef, int id) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:80/api/Ingredients/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'mealRef': mealRef,
      'ingredientRef': ingredientRef,
      'id': id,
    }),
  );

  return response;
}

Future<http.Response> deletePackedIngredient(int id) async {
  final response = await http.delete(
    Uri.parse('http://127.0.0.1:80/api/Ingredients/Delete/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  return response;
}