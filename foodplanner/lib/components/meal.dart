import 'package:foodplanner/components/packed_ingredient.dart';

// Class representing a Meal
class Meal {
  final int id; // Unique identifier for the meal
  // final User user;
  final String title; // Title of the meal
  final String? imageUrl; // Optional image representation of the meal
  final DateTime? date; // Optional date when the meal is planned
  final List<PackedIngredient> ingredients; // List of packed ingredients used in the meal

  // Constructor for the Meal class with default values
  const Meal({
    this.id = 0, // Default ID is  0 if not specified
    // this.user = new User(),
    this.title = '',  // Default title is an empty string if not specified
    this.imageUrl = '', // Default image is null if not specified
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
      // user: json['user] != null ? json['user'] as User ? null,
      title: json['title'] != null ? json['title'] as String : '',
      imageUrl: json['imageUrl'] != null ? json['imageUrl'] as String : null,
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : null,
      ingredients: (json['ingredients'] as List<dynamic>?)?.map((item) => PackedIngredient.fromJson(item as Map<String, dynamic>)).toList() ?? [],
    );
  }

  // Method to convert Meal instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'user': user,
      'title': title,
      'image': imageUrl,
      'date': date?.toIso8601String(),
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
    };
  }
}
    
    // return switch (json) {
    //   {
    //     'id': int id, // Expeting 'id' to be an integer
    //     // 'user': User user,
    //     'title': String title, // Expecting 'titile' to be a URL string
    //     'image': String imageUrl, // Expecting 'image' to be a URL string
    //     'date' : DateTime date, // Expecting 'date' to be a DataTime object
    //     'ingredients': List<PackedIngredient> ingredients, // Expecting 'ingredients' to be a list
    //   } =>
    //     Meal(
    //       id: id, // Assigning the oarse ID
    //       // user: user,
    //       title: title, // Assigning the parsed title
    //       image: Image.network(imageUrl), // Creating an Image from the URL
    //       date: date, // Assigning the parsed date
    //       ingredients: ingredients, // Assigning the parsed ingredients
    //     ),
    //   _ => throw const FormatException('Måltid kunne ikke findes.'), // Error handling for unexpected formats
    // };
//   }
// }