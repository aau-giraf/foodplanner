import 'package:flutter/material.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';

class FoodImage extends StatelessWidget {
  final int foodImageId;

  FoodImage({required this.foodImageId});

  // A method to create an instance from JSON
  factory FoodImage.fromJson(Map<String, dynamic> json) {
    return FoodImage(
      foodImageId: json['foodImageId'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: ImagesApi()
            .apiImagesGetPresignedImageLinkGet(foodImageId: foodImageId),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(snapshot.data!),
            );
          } else {
            return Text("Image not found");
          }
        });
  }
}
