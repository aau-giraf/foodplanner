import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/components/packed_ingredient.dart';
import 'package:http/http.dart' as http;

Future<Meal> fetchMeal(int id) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:80/api/Meals/Get/$id'));

  if (response.statusCode == 200) {
    return Meal.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Kunne ikke hente måltidet');
  }
}

Future<http.Response> createMeal(/*final User user,*/ final String title, final Image? image, final DateTime? date, final List<PackedIngredient> ingredients) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:80/api/Meals/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
        // 'user': user,
        'title': title,
        'image': image.toString(),
        'date': date,
        'ingredients': ingredients,
    }),
  );

  return response;
}

Future<http.Response> deleteMeal(int id) async {
  final response = await http.delete(
    Uri.parse('http://127.0.0.1:80/api/Meals/Delete/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  return response;
}