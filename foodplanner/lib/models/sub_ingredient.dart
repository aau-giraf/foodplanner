// Class representing a SubIngredient

class SubIngredient {
  final int id; 
  final String name;
  final int userID;
  final int foodImageId;

  
  const SubIngredient({
    this.id = 0, 
    this.name = '', 
    this.userID = 0,
    this.foodImageId = 0,
  });


  
  factory SubIngredient.fromJson(Map<String, dynamic> json) {
    return SubIngredient(
      id: (json['id'] != null)? json['id'] as int : 0,
      name: json['name'] != null ? json['name'] as String : '',
      userID: json['user_id'] != null ? json['user_id'] as int : 0,
      foodImageId: json['food_image_id'] != null ? json['food_image_id'] as int : 0,
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'user_id': userID,
      'food_image_id': foodImageId
    };
  }
  
}


