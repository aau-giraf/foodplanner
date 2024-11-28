import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<http.Response> UploadFoodImage(XFile image) async {
  final jwtToken =
      await AuthProvider().retrieveToken(); // Get the authorization token
  final client = http.Client();

  try {
    // Initialize the MultipartRequest for a file upload
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/api/Images/UploadImage'),
    );

    // Add the authorization header
    request.headers['Authorization'] = 'Bearer $jwtToken';

    /* var multipartFile = http.MultipartFile.fromBytes(
      'file',
      imageBytes,
      filename: 'food_image.jpg',
      contentType: MediaType('image', 'jpeg'),
    ); */

    final imageBytes = await image.readAsBytes();

    // Create a MultipartFile from the bytes
    final multipartFile = http.MultipartFile.fromBytes(
      'imageFile',
      imageBytes,
      filename: 'image.png',
      contentType: MediaType('image', 'png'),
    );

    // Add the file to the request as a form field
    request.files.add(multipartFile);

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
