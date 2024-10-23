import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodImage {

  final int foodImageId;

  FoodImage({required this.foodImageId});

  // A method to create an instance from JSON
  factory FoodImage.fromJson(Map<String, dynamic> json) {
    return FoodImage(
      foodImageId: json['foodImageId'],
    );
  }

  Future<FoodImage> fetchImage() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:80/api/Images/GetPresignedImageLink'));

    if (response.statusCode == 200) {
      return FoodImage.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Kunne ikke hente billede');
    }
  }
}