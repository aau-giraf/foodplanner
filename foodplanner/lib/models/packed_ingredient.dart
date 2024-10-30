import 'package:foodplanner/models/ingredient.dart';

// Class representing a PackedIngredient
class PackedIngredient {
  final int mealRef; // Reference ID for the associated meal
  Ingredient ingredientRef; // Reference to the Ingredient object
  final int id; // Reference to the Ingredient object

  // Constructor for the PackedIngredient class with default values
  PackedIngredient({
    this.mealRef = 0, // Default meal reference is 0 if not specified
    this.ingredientRef = const Ingredient(userRef: 1), // Default ingredient reference is a new Ingredient instance
    this.id = 0, // Default ID is 0 if not specified
  });

  // Setter method to update the ingredient reference
  void set setIngredientRef(Ingredient _ingredientRef) {
    ingredientRef = _ingredientRef; // Update the ingredient reference
  }

  // Factory constructor to create a PackedIngredient instance from a JSON map
  factory PackedIngredient.fromJson(Map<String, dynamic> json) {
    return PackedIngredient(
      mealRef: json['mealRef'] != null ? json['mealRef'] as int : 0, // Parsing meal reference from JSON
      ingredientRef: Ingredient.fromJson(json['ingredientRef'] as Map<String, dynamic>), // Parsing ingredient reference
      id: json['id'] != null ? json['id'] as int : 0, // Parsing ID from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealRef': mealRef,
      'ingredientRef': ingredientRef.toJson(),
    };
  }
}