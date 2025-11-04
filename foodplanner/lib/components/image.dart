import 'package:flutter/material.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:http/http.dart' as http;

class FoodImage extends StatelessWidget {
  final int? foodImageId;
  final double width;
  final double height;
  final double borderRadius;
  final imageUrl = 'https://cdn-icons-png.flaticon.com/512/739/739249.png';

  const FoodImage({super.key,
    required this.foodImageId,
    this.width = 250,
    this.height = 250,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
        future: loadImageAndToken(),
        builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
          if (!snapshot.hasError && snapshot.hasData) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: Image(
                  image: snapshot.data!,
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ));
          } else {
            return ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Image.network(
                imageUrl,
                width: width,
                height: height,
                fit: BoxFit.cover,
              ),
            );
          }
        });
  }

  Future<ImageProvider> loadImageAndToken() async {
    String? jwtToken = await AuthProvider().retrieveToken();

    var apiClient = ApiClient();
    apiClient.addDefaultHeader('Authorization', 'Bearer $jwtToken');

    var imagesApi = ImagesApi(apiClient);

    if (foodImageId == null) {
      return NetworkImage(imageUrl);
    }

    try {
      String? tempImageUrl = await imagesApi.apiImagesGetPresignedImageLinkGet(
          foodImageId: foodImageId);

      tempImageUrl = tempImageUrl?.replaceFirst(
          'http://localhost:9000', 'http://localhost:9000');

      final response = await http.get(Uri.parse(tempImageUrl!));
      if (response.statusCode == 200) {
        return NetworkImage(tempImageUrl);
      } else {
        return NetworkImage(imageUrl);
      }
    } catch (e) {
      return NetworkImage(imageUrl);
    }
  }
}
