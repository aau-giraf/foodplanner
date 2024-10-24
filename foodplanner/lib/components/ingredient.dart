import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/packed_ingredient.dart';
import 'package:http/http.dart' as http;

class Ingredient {
  final int id;
  final String name;
  // final User user;
  final Image? image;
  

  const Ingredient({
    this.id = 0,
    this.name = '',
    // this.user,
    this.image,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        // 'user': User user,
        'image': Image image,
      } =>
        Ingredient(
          name: name,
          // user: user,
          image: image,
        ),
      _ => throw const FormatException('Ingrediens kunne ikke findes.'),
    };
  }
}

Future<Ingredient> fetchIngredient(int id) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/$id'));

  if (response.statusCode == 200) {
    return Ingredient.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Kunne ikke hente ingrediens');
  }
}

// !!! Chat GPT !!!
  // Helper method to fetch ingredients asynchronously
  Future<List<Ingredient>> fetchIngredientsByPackedList(List<PackedIngredient> packedIngredients) async {
    List<Ingredient> ingredients = [];
    for (var packedIngredient in packedIngredients) {
      final ingredient = await fetchIngredient(packedIngredient.ingredientRef as int);
      ingredients.add(ingredient); // Await each fetchIngredient and add to the list
    }
    return ingredients;
  }

Future<List<Ingredient>> fetchIngredientsByUserID(int userID) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/$userID'));

  if (response.statusCode == 200) {
    List<Ingredient> ingredients = <Ingredient>[];
    List<String> encodedIngredients = response.body.split('},{');
    encodedIngredients.forEach((encodedIngredient) {
      ingredients.add(Ingredient.fromJson(jsonDecode(encodedIngredient) as Map<String, dynamic>));
    });
    return ingredients;
  } else {
    throw Exception('Kunne ikke hente ingredienser');
  }
}

Future<http.Response> createIngredient(String name, /*User user, */ Image image) async {
  final auth = AuthProvider();

  final response = await http.post(
    Uri.parse('http://127.0.0.1:80/api/Ingredients/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer: ${auth.retrieveToken}',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      // 'user': user,
      'image': image.toString(),
    }),
  );

  return response;
}

Future<http.Response> deleteIngredient(int id) async {
  final response = await http.delete(
    Uri.parse('http://127.0.0.1:80/api/Ingredients/Delete/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  return response;
}