import 'dart:io';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/services/api_config.dart';

Future<http.Response> UploadFoodImage(http.Client client, File image) async {
  final jwtToken = await AuthProvider().retrieveToken(); // Get the authorization token from authentication provider 

  // Make a POST request to the API to create a new ingredient.
  final response = await client.post(
    Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8', // Specify the content type as JSON.
      'Authorization': 'Bearer $jwtToken', // Include the authorization token for authentication.
    },
    body: image
  );

  return response; // Return the response from the API call.
}
