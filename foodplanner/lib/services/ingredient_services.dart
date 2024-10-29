import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:http/http.dart' as http;

/// Fetch a specific ingredient by its ID from the API.
Future<Ingredient> fetchIngredient(http.Client client, int id) async {
    // Make a GET request to the API to retrieve an ingredient by ID.
  final response =
      await client.get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/$id'));

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
Future<List<Ingredient>> fetchIngredientsByUserID(http.Client client, int userID) async {
  // Make a GET request to the API to retrieve ingredients by user ID.
  final response =
      await client.get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/$userID'));

  // Check if the request was successful (status code 200).
  if (response.statusCode == 200) {
    List<Ingredient> ingredients = <Ingredient>[]; // Create an empty list to hold the ingredients.
    // Split the response body into individual ingredient strings.
    List<String> encodedIngredients = response.body.split('},{');

    // Iterate over the encoded ingredients and convert them to Ingredient objects.
    encodedIngredients.forEach((encodedIngredient) {
      ingredients.add(Ingredient.fromJson(jsonDecode(encodedIngredient) as Map<String, dynamic>)); // Decode and add each ingredient to the list.
    });
    return ingredients; // Return the list of ingredients.
  } else {
    // If the request failed, throw an exception with an error message.
    throw Exception('Kunne ikke hente ingredienser'); // "Could not fetch ingredients"
  }
}

// Create a new ingredient via a POST request to the API.
Future<http.Response> createIngredient(http.Client client, String name, int userRef,  String? imageUrl) async {
  final auth = AuthProvider(); // Get the authentication provider instance.

  // Make a POST request to the API to create a new ingredient.
  final response = await client.post(
    Uri.parse('http://127.0.0.1:80/api/Ingredients/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8', // Specify the content type as JSON.
      'Authorization': 'Bearer: ${auth.retrieveToken}', // Include the authorization token for authentication.
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
  // Make a DELETE request to the API to remove the ingredient by ID.
  final response = await client.delete(
    Uri.parse('http://127.0.0.1:80/api/Ingredients/Delete/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',  // Specify the content type as JSON.
    },
  );
  return response; // Return the response from the API call.
}