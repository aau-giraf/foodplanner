import 'package:foodplanner/models/packed_ingredient.dart';

// Class representing a Meal
class Meal {
  final int id; // Unique identifier for the meal
  final String title; // Title of the meal
  final int? imageRef; // Optional image representation of the meal
  final DateTime? date; // Optional date when the meal is planned
  final List<PackedIngredient>
      ingredients; // List of packed ingredients used in the meal

  // Constructor for the Meal class with default values
  const Meal({
    this.id = 0, // Default ID is  0 if not specified
    this.title = '', // Default title is an empty string if not specified
    this.imageRef, // Default image is null if not specified
    this.date, // Default date is null if not specified
    this.ingredients = const <PackedIngredient>[], // Default ingredients list
  });

  // Getter to retrieve the list of packed ingredient
  List<PackedIngredient> get getPackedIngredients {
    return this.ingredients;
  }

  // Factory constructor to create a Meal instance from a JSON map
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] != null ? json['id'] as int : 0,
      title: json['title'] != null ? json['title'] as String : '',
      imageRef: json['image_ref'] != null ? json['image_ref'] as int : null,
      date:
          json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      ingredients: (json['ingredients'] as List)
          .map((e) => PackedIngredient.fromJson(e))
          .toList(),
    );
  }

  // Method to convert Meal instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_ref': imageRef,
      'date': date?.toIso8601String(),
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
    };
  }
}
