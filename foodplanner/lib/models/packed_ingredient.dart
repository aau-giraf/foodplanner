import 'package:foodplanner/models/ingredient.dart';

// Class representing a PackedIngredient
class PackedIngredient {
  final int mealId; // Reference ID for the associated meal
  Ingredient ingredient; // Reference to the Ingredient object
  final int id; // Reference to the Ingredient object
  int orderNumber;

  // Constructor for the PackedIngredient class with default values
  PackedIngredient({
    this.mealId = 0, // Default meal reference is 0 if not specified
    this.ingredient =
        const Ingredient(), // Default ingredient reference is a new Ingredient instance
    this.id = 0, // Default ID is 0 if not specified
    this.orderNumber = 0,
  });

  // Factory constructor to create a PackedIngredient instance from a JSON map
  factory PackedIngredient.fromJson(Map<String, dynamic> json) {
    return PackedIngredient(
      mealId: json['meal_id'] != null
          ? json['meal_id'] as int
          : 0, // Parsing meal reference from JSON
      ingredient: Ingredient.fromJson(json['ingredient_id']
          as Map<String, dynamic>), // Parsing ingredient reference
      id: json['id'] != null ? json['id'] as int : 0, // Parsing ID from JSON
      orderNumber: json['order_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meal_id': mealId,
      'ingredient_id': ingredient.id,
    };
  }
}
