import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/services/api_config.dart';

// Fetches a meal by its ID from the server.
// Takes an HTTP client and the meal ID as parameters.
/// Returns a Meal object if successful, or throws an exception if not.
Future<Meal> fetchMeal(http.Client client, int id) async {
  final jwtToken = await AuthProvider().retrieveToken();
  // Making a GET request to the API to fetch meal details by ID.
  final response =
      await client.get(Uri.parse('${ApiConfig.baseUrl}/api/Meals/Get/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );
  // Checking if the server returned a successful response.
  if (response.statusCode == 200) {
    // If successful, parse the response and return a Meal object.
      return Meal.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If not successful, throw an exception with an error message.
    throw Exception('Kunne ikke hente måltidet');
  }
}

// Creates a new meal on the server.
// Takes an HTTP client, meal title, optional image URL, optional date, and a list of ingredients.
// Returns the server's response.
Future<http.Response> createMeal(http.Client client, /*final User user,*/ final String title, final String? imageUrl, final DateTime? date, final List<PackedIngredient> ingredients) async {
  final jwtToken = await AuthProvider().retrieveToken();
  // Sending a POST request to the API endpoint to create a new meal.
  final response = await client.post(
    Uri.parse('${ApiConfig.baseUrl}/api/Meals/Create'), // Specify the API endpoint for meal creation.
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8', // Specify that the content is JSON.
      'Authorization': 'Bearer $jwtToken'
    },
    // Encode the meal data as JSON for the request body.
    body: jsonEncode({
        // 'user': user,
        'title': title, // Meal title.
        'image': imageUrl, // Meal image URL (ensured to be a string).
        'date': date?.toIso8601String(), // Optional date for the meal.
        'ingredients': ingredients.map((e) => e.toJson()).toList(), // List of PackedIngredient objects.
    }),
  );
  return response;   // Return the response from the server.
}

// Deletes a meal from the server by its ID.
// Takes an HTTP client and the meal ID as parameters.
// Returns the server's response after attempting to delete the meal.
Future<http.Response> deleteMeal(http.Client client, int id) async {
  final jwtToken = await AuthProvider().retrieveToken();
  // Sending a DELETE request to the API endpoint to remove a meal by ID.
  final response = await client.delete(
    Uri.parse('${ApiConfig.baseUrl}/api/Meals/Delete/$id'),  // Specify the API endpoint for meal deletion.
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8', // Specify that the content is JSON.
      'Authorization': 'Bearer $jwtToken'
    },
  );
  return response; // Return the response from the server.
}