import 'package:flutter/material.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';

class FoodImage extends StatelessWidget {
  final int foodImageId;

  FoodImage({required this.foodImageId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: ImagesApi(ApiClient(authentication: HttpBearerAuth().accessToken(AuthProvider().retrieveToken())))
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
