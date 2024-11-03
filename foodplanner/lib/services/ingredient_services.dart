import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/services/api_config.dart';

/// Fetch a specific ingredient by its ID from the API.
Future<Ingredient> fetchIngredient(http.Client client, int id) async {
  final jwtToken = await AuthProvider().retrieveToken();
    // Make a GET request to the API to retrieve an ingredient by ID.
  final response =
      await client.get(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Get/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

  // Check if the request was successful (status code 200).
  if (response.statusCode == 200) {
    // Decode the JSON response and create an Ingredient object from it.
    return Ingredient.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the request failed, throw an exception with an error message.
    throw Exception('Kunne ikke hente ingrediens');  // "Could not fetch ingredient"
  }
}

// Fetch all ingredients for a specific user by their user ID.
Future<List<Ingredient>> fetchIngredientsByUserID(http.Client client) async {
  final jwtToken = await AuthProvider().retrieveToken();
  // Make a GET request to the API to retrieve ingredients by user ID.
  final response =
      await client.get(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Get'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );
  // Check if the request was successful (status code 200).
  if (response.statusCode == 200) {
    // Decode the response body directly into a list.
    List<dynamic> jsonResponse = jsonDecode(response.body);
    
    // Map the JSON list to a List<Ingredient>
    List<Ingredient> ingredients = jsonResponse.map((ingredientJson) {
      return Ingredient.fromJson(ingredientJson as Map<String, dynamic>);
    }).toList();

    return ingredients;
  } else {
    // If the request failed, throw an exception with an error message.
    throw Exception('Kunne ikke hente ingredienser'); // "Could not fetch ingredients"
  }
}


// Create a new ingredient via a POST request to the API.
Future<http.Response> createIngredient(http.Client client, String name, int userRef,  String? imageUrl) async {
  final jwtToken = await AuthProvider().retrieveToken(); // Get the authorization token from authentication provider 

  // Make a POST request to the API to create a new ingredient.
  final response = await client.post(
    Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8', // Specify the content type as JSON.
      'Authorization': 'Bearer $jwtToken', // Include the authorization token for authentication.
    },
    body: jsonEncode(<String, String>{ // Encode the request body as JSON.
      'name': name, // Name of the ingredient.
      'userRef': userRef.toString(),
      'image': imageUrl as String, // Image URL of the ingredient (optional).
    }),
  );

  return response; // Return the response from the API call.
}

// Delete an ingredient by its ID via a DELETE request to the API.
Future<http.Response> deleteIngredient(http.Client client, int id) async {
  final jwtToken = await AuthProvider().retrieveToken();
  // Make a DELETE request to the API to remove the ingredient by ID.
  final response = await client.delete(
    Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Delete/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',  // Specify the content type as JSON.
      'Authorization': 'Bearer $jwtToken',
    },
  );
  return response; // Return the response from the API call.
}