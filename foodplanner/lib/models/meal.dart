import 'package:foodplanner/models/packed_ingredient.dart';

// Class representing a Meal
class Meal {
  final int id; // Unique identifier for the meal
  final String name; // Title of the meal
  final int? foodImageId; // Optional image representation of the meal
  final DateTime? date; // Optional date when the meal is planned
  final List<PackedIngredient>
      ingredients; // List of packed ingredients used in the meal

  final bool template; // Indicates if the meal is a template meal      

  // Constructor for the Meal class with default values
  const Meal({
    this.id = 0, // Default ID is  0 if not specified
    this.name = '', // Default title is an empty string if not specified
    this.foodImageId, // Default image is null if not specified
    this.date, // Default date is null if not specified
    this.ingredients = const <PackedIngredient>[], // Default ingredients list
    this.template = false, // Default template status is false
   
  });

  // Getter to retrieve the list of packed ingredient
  List<PackedIngredient> get getPackedIngredients {
    return this.ingredients;
  }

  // Factory constructor to create a Meal instance from a JSON map
  factory Meal.fromJson(Map<String, dynamic> json) {
  
    return Meal(
      id: json['id'] != null ? json['id'] as int : 0,
      name: json['name'] != null ? json['name'] as String : '',
      foodImageId:
          json['food_image_id'] != null ? json['food_image_id'] as int : null,
      date:
          json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      ingredients: (json['ingredients'] as List)
          .map((e) => PackedIngredient.fromJson(e))
          .toList(),
      template: json['template'] != null ? json['template'] as bool : false,
    );
  }

  // Method to convert Meal instance to JSON map
  Map<String, dynamic> toJson() {
    
    return {
      'id': id,
      'name': name,
      'food_image_id': foodImageId,
      'date': date?.toIso8601String(),
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'template': template,
    };
  }
}
