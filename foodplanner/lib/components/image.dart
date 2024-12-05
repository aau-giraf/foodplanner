import 'package:flutter/material.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:http/http.dart' as http;

class FoodImage extends StatelessWidget {
  final int? foodImageId;
  final imageUrl = 'https://cdn-icons-png.flaticon.com/512/739/739249.png';

  FoodImage({required this.foodImageId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ImageProvider>(
        future: loadImageAndToken(),
        builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
          if (!snapshot.hasError && snapshot.hasData) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: snapshot.data!,
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
          'http://localhost:9000', 'http://10.92.0.69:9000');

      final response = await http.get(Uri.parse(tempImageUrl!));
      if (response.statusCode == 200) {
        return NetworkImage(tempImageUrl);
      } else {
        return NetworkImage(imageUrl);
      }
    } catch (e) {
      print("error");
      return NetworkImage(imageUrl);
    }
  }
}
