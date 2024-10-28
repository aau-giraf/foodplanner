import 'dart:convert';

import 'package:foodplanner/api/openapi/lib/api.dart';

class FoodImage {
  final int foodImageId;

  FoodImage({required this.foodImageId});

  factory FoodImage.fromJson(Map<String, dynamic> json) {
    return FoodImage(
      foodImageId: json['foodImageId'],
    );
  }

  Future<FoodImage> fetchImage() async {
    final response = await ImagesApi()
        .apiImagesGetPresignedImageLinkGetWithHttpInfo(
            foodImageId: foodImageId);

    if (response.statusCode == 200) {
      return FoodImage.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Kunne ikke hente billede');
    }
  }
}
