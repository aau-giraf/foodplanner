import 'package:flutter/material.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';

class FoodImage extends StatelessWidget {
  final int? foodImageId;
  final imageUrl = 'https://cdn-icons-png.flaticon.com/512/739/739249.png';

  FoodImage({required this.foodImageId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: loadImageAndToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: NetworkImage(snapshot.data!),
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ));
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(imageUrl),
            );
          }
        });
  }

  Future<String?> loadImageAndToken() async {
    String? jwtToken = await AuthProvider().retrieveToken();

    var apiClient = ApiClient();
    apiClient.addDefaultHeader('Authorization', 'Bearer $jwtToken');

    var imagesApi = ImagesApi(apiClient);

    if (foodImageId == null) {
      return null;
    }

    String? imageUrl = await imagesApi.apiImagesGetPresignedImageLinkGet(
        foodImageId: foodImageId);

    print('Image URL: $imageUrl');

    imageUrl = imageUrl?.replaceFirst(
        'http://localhost:9000', 'https://0812sjhc-9000.euw.devtunnels.ms');

    return imageUrl;
  }
}
