import 'dart:ffi';

class Ingredient {
  final int id;
  final String name;
  final int userId;
  final int? foodImageId;

  const Ingredient({
    required this.id,
    required this.name,
    required this.userId,
    this.foodImageId,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'name': String name,
        'user_id': int userId,
        'food_image_id': int? foodImageId,
      } =>
        Ingredient(
          id: id,
          name: name,
          userId: userId,
          foodImageId: foodImageId,
        ),
      _ => throw const FormatException('Ingredient kunne ikke findes.'),
    };
  }
}

class PackedIngredients {
  final int id;
  final int mealId;
  final Ingredient ingredient;

  const PackedIngredients({
    required this.id,
    required this.mealId,
    required this.ingredient,
  });

  factory PackedIngredients.fromJson(Map<String, dynamic> json) {
    return PackedIngredients(
      id: json['id'],
      mealId: json['meal_id'],
      ingredient: Ingredient.fromJson(json['ingredient_id']),
    );
  }

  static List<PackedIngredients> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PackedIngredients.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

class Meal {
  final int id;
  final int? foodImageId;
  final String name;
  final String date;
  final List<PackedIngredients> packedIngredients;

  const Meal({
    required this.id,
    required this.foodImageId,
    required this.name,
    required this.date,
    required this.packedIngredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      foodImageId: json['food_image_id'],
      name: json['name'],
      date: json['date'],
      packedIngredients: PackedIngredients.fromJsonList(json['ingredients']),
    );
  }
}
