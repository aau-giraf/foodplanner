import 'package:flutter/material.dart';

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