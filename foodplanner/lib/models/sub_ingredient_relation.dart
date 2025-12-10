// Class representing a SubIngredientRelation

import 'package:foodplanner/models/sub_ingredient.dart';

class SubIngredientRelation {
  final int id; 
  final int ingredientId; 
  final SubIngredient? subIngredient; 
  final int? orderNumber;

  
  const SubIngredientRelation({
    this.id = 0,
    this.ingredientId = 0,
    this.subIngredient,
    this.orderNumber,
  });


  factory SubIngredientRelation.fromJson(Map<String, dynamic> json) {
    return SubIngredientRelation(
      id: json['id'] != null ? json['id'] as int:  0,
      ingredientId: json['ingredient_id'] != null ? json['ingredient_id'] as int : 0,
      subIngredient:
         SubIngredient.fromJson(json['subingredient_id'] as Map<String, dynamic>),
      orderNumber: json['order_number'] as int?,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingredient_id': ingredientId,
     
      'subingredient_id': subIngredient,
      'order_number': orderNumber,
    };
  }
}


