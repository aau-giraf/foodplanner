// Class representing an Ingredient
class Ingredient {
  final int id; // Unique identifier for the ingredient
  final String name; // Name of the ingredient
  final int? foodImageId; // Optional image representation of the ingredient

  // Constructor for the Ingredient class with default values
  const Ingredient({
    this.id = 0, // Default ID is 0 if not specified
    this.name = '', // Default name is an empty string if not specified
    this.foodImageId, // Default is null if not specified
  });

  // Factory constructor to create an Ingredient instance from a JSON map
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as int? ??
          0, // Parsing the ID from the JSON, defaulting to 0 if null
      name: json['name'] as String? ??
          '', // Parsing the name from the JSON, defaulting to an empty string if null
      foodImageId: int.tryParse(json['food_image_id'].toString()) ?? 0,
    );
  }

  // Method to convert an Ingredient instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'food_image_id': foodImageId,
    };
  }
}
