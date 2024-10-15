import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:foodplanner/components/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Meal {
  final int id;
  final String name;
  final String? description;
  final Image? image;
  final List<Ingredient> ingredients;
  final String altText;

  const Meal({
    required this.id,
    required this.name,
    this.description,
    this.image,
    required this.ingredients,
    required this.altText,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'description': String description,
        'image': Image image,
        'ingredients': List<Ingredient> ingredients,
        'alt_text': String altText,
      } =>
        Meal(
          id: id,
          name: name,
          description: description,
          image: image,
          ingredients: ingredients,
          altText: altText,
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

Future<http.Response> createMeal(int id, String name, String description, Image image, List<Ingredient> ingredients,
    String altText) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:80/api/Meals/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
        'id': id,
        'name': name,
        'description': description,
        'image': image.toString(),
        'ingredients': ingredients,
        'alt_text': altText,
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