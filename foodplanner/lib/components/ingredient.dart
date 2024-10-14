import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ingredient {
  final String name;
  final String? description;
  final Image? image;
  final String altText;
  final String attributes;
  

  const Ingredient({
    required this.name,
    this.description,
    this.image,
    required this.altText,
    required this.attributes,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'name': String name,
        'description': String? description,
        'image': Image image,
        'altText': String altText,
        'attributes': String attributes,
      } =>
        Ingredient(
          name: name,
          description: description,
          image: image,
          altText: altText,
          attributes: attributes,
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

Future<http.Response> createIngredient(String name, String description,
    Image image, String altText, String attributes) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:80/api/Ingredients/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'description': description,
      'image': image.toString(),
      'altText': altText,
      'attribute': attributes
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