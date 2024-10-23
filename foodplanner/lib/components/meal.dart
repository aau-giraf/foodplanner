import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodplanner/components/packed_ingredient.dart';
import 'package:http/http.dart' as http;

class Meal {
  final int id;
  // final User user;
  final String title;
  final Image? image;
  final DateTime? date;
  final List<PackedIngredient> ingredients;

  const Meal({
    this.id = 0,
    // this.user = new User(),
    this.title = '',
    this.image,
    this.date,
    this.ingredients = const <PackedIngredient>[],
  });

  List<PackedIngredient> get getPackedIngredients {
    return this.ingredients;
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        // 'user': User user,
        'title': String title,
        'image': Image image,
        'date' : DateTime date,
        'ingredients': List<PackedIngredient> ingredients,
      } =>
        Meal(
          id: id,
          // user: user,
          title: title,
          image: image,
          date: date,
          ingredients: ingredients,
        ),
      _ => throw const FormatException('Måltid kunne ikke findes.'),
    };
  }
}

Future<Meal> fetchMeal(int id) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:80/api/Meals/Get/$id'));

  if (response.statusCode == 200) {
    return Meal.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Kunne ikke hente måltidet');
  }
}

Future<http.Response> createMeal(final int id, /*final User user,*/ final String title, final Image? image, final DateTime? date, final List<PackedIngredient> ingredients) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:80/api/Meals/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
        'id': id,
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