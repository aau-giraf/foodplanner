import 'dart:convert';
import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:foodplanner/api/generator/openapi_config.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:http/http.dart' as http;
import 'package:openapi_generator_annotations/openapi_generator_annotations.dart';

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
    ImagesApi().apiImagesGetPresignedImageLinkGet(foodImageId: 1);

    final response = await http
        .get(Uri.parse('http://127.0.0.1:80/api/Images/GetPresignedImageLink'));

    if (response.statusCode == 200) {
      return FoodImage.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Kunne ikke hente billede');
    }
  }
}
