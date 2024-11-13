import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// This method is used to send the inputted image to the back-end.
// Future<Response> UploadFoodImage(ApiClient client, MultipartFile image) async {
//   // final jwtToken = await authProvider.retrieveToken(); // Get the authorization token from authentication provider 

//   final imagesApi = ImagesApi(client);

//   try{
//     final response = await imagesApi.apiImagesUploadImagePostWithHttpInfo(
//       userId: 5,
//       imageFile: image,
//     );
//     if(response.statusCode == 200) {
//       return response;
//     } else {
//       throw Exception("Failed to upload image: ${response?.statusCode}");
//     }
//   } catch (exception) {
//     throw Exception("Image upload failed: $exception");
//   }
// }

// Future<Response> UploadFoodImage(http.Client client, MultipartFile image) async {
//   final jwtToken = await AuthProvider().retrieveToken(); // Get the authorization token from authentication provider 

//   try{
//     final response = await client.post(
//       Uri.parse('${ApiConfig.baseUrl}/api/Images/UploadImage'), // Specify the API endpoint for meal creation.
//       headers: <String, String>{
//         'Content-Type': 'multipart/form-data', // Specify that the content is JSON.
//         'Authorization': 'Bearer $jwtToken'
//       },
//       body: image
//     );

//     if(response.statusCode == 200) {
//       return response;
//     } else {
//       throw Exception("Failed to upload image: ${response!.statusCode}");
//     }
//   } catch (exception) {
//     throw Exception("Image upload failed: $exception");
//   }
// }

Future<http.Response> UploadFoodImage(http.Client client, http.MultipartFile image) async {
  final jwtToken = await AuthProvider().retrieveToken(); // Get the authorization token

  try {
    // Initialize the MultipartRequest for a file upload
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/api/Images/UploadImage'),
    );

    // Add the authorization header
    request.headers['Authorization'] = 'Bearer $jwtToken';

    // Add the file to the request as a form field
    request.files.add(image);

    // Send the multipart request
    final streamedResponse = await client.send(request);

    // Convert the streamed response to a Response object
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to upload image: ${response.statusCode}");
    }
  } catch (exception) {
    throw Exception("Image upload failed: $exception");
  }
}