import 'dart:convert';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:http/http.dart' as http;

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