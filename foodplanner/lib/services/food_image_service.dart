import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:http/http.dart' as http;

Future<http.Response> UploadFoodImage(http.MultipartFile image) async {
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
