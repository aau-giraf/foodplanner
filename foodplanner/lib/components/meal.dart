import 'package:flutter/material.dart';
import 'package:foodplanner/components/packed_ingredient.dart';

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