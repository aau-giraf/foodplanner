import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/services/api_config.dart';


// Fetches a PackedIngredient by its ID from the server.
// Takes an HTTP client and the packed ingredient ID as parameters.
// Returns a PackedIngredient object if the request is successful, or throws an exception if the request fails.
Future<PackedIngredient> fetchPackedIngredient(http.Client client, int id) async {
  final jwtToken = await AuthProvider().retrieveToken();
  // Sending a GET request to the API endpoint to retrieve a packed ingredient by the specified ID.
  final response =
      await client.get(Uri.parse('${ApiConfig.baseUrl}/api/PackedIngredient/Get/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

  // Check if the server returned a successful response (status code 200).
  if (response.statusCode == 200) {
    // If successful, decode the JSON response and create a PackedIngredient object from it.
    return PackedIngredient.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the response is not successful, throw error message.
    throw Exception('Kunne ikke hente ingrediens');
  }
}

// Creates a new PackedIngredient on the server.
// Takes an HTTP client, a reference to a meal, a reference to an ingredient,
// and the packed ingredient ID as parameters.
// Returns the server's response after attempting to create the packed 
Future<http.Response> createPackedIngredient(http.Client client, int meal_ref, int ingredient_ref) async {
  final jwtToken = await AuthProvider().retrieveToken();
  // Sending a POST request to the API endpoint to create a new packed ingredient.
  final response = await client.post(
    Uri.parse('${ApiConfig.baseUrl}/api/PackedIngredient/Create'), // Specify the API endpoint for creating packed ingredients.
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8', // Specify that the content is JSON.
      'Authorization': 'Bearer $jwtToken',
    },
    // Encode the packed ingredient data as JSON for the request body.
    body: jsonEncode({
      'meal_ref': meal_ref, // Reference ID for the meal the ingredient is associated with.
      'ingredient_ref': ingredient_ref, // ID of the ingredient being packed.
    }),
  );
  return response;   // Return the response from the server.
}

// Deletes a PackedIngredient from the server by its ID.
// Takes an HTTP client and the packed ingredient ID as parameters.
// Returns the server's response after attempting to delete the packed ingredient.
Future<http.Response> deletePackedIngredient(http.Client client, int id) async {
  final jwtToken = await AuthProvider().retrieveToken();
  // Sending a DELETE request to the API endpoint to remove a packed ingredient by ID.
  final response = await client.delete(
    Uri.parse('${ApiConfig.baseUrl}/api/PackedIngredient/Delete/$id'), // Specify the API endpoint for deleting packed ingredients.
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',  // Specify that the content is JSON.
      'Authorization': 'Bearer $jwtToken',
    },
  );
  return response;   // Return the response from the server.
}