import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/services/api_config.dart';
import 'package:intl/intl.dart';

// Fetches a meal by its ID from the server.
// Takes an HTTP client and the meal ID as parameters.
/// Returns a Meal object if successful, or throws an exception if not.
Future<Meal> fetchMeal(
    http.Client client, AuthProvider authProvider, int id) async {
  final jwtToken = await authProvider.retrieveToken();
  // Making a GET request to the API to fetch meal details by ID.
  final response = await client.get(
    Uri.parse('${ApiConfig.baseUrl}/api/Meals/Get/$id'),
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
Future<http.Response> createMeal(AuthProvider authProvider, final String name,
    final int? foodImageId, final DateTime? date, {http.Client? client}) async {
      
  // Optional client for tests
  client ??= http.Client();

  final jwtToken = await authProvider.retrieveToken();
  // Sending a POST request to the API endpoint to create a new meal.
  final response = await client.post(
    Uri.parse(
        '${ApiConfig.baseUrl}/api/Meals/Create'), // Specify the API endpoint for meal creation.
    headers: <String, String>{
      'Content-Type':
      'application/json; charset=UTF-8', // Specify that the content is JSON.
      'Authorization': 'Bearer $jwtToken'
    },
    // Encode the meal data as JSON for the request body.
    body: jsonEncode({
      'id': 0,
      'name': name, // Meal title.
      'food_image_id': foodImageId,
      'date':
          DateFormat('yyyy-MM-dd').format(date!), // Optional date for the meal.
    }),
  );
  print('Statuscode: ${response.statusCode} body:${response.body}');
  return response; // Return the response from the server.
}

// Updates a meal on the server.
// Takes an HTTP client, and the changed meal as inputs.
// Returns the server's response.
Future<http.Response> updateMeal(
    http.Client client, AuthProvider authProvider, final Meal meal) async {
  final jwtToken = await authProvider.retrieveToken();
  // Sending a POST request to the API endpoint to create a new meal.
  final response = await client.put(
    Uri.parse(
        '${ApiConfig.baseUrl}/api/Meals/Update/${meal.id}'), // Specify the API endpoint for meal creation.
    headers: <String, String>{
      'Content-Type':
          'application/json; charset=UTF-8', // Specify that the content is JSON.
      'Authorization': 'Bearer $jwtToken'
    },
    // Encode the meal data as JSON for the request bodyy with date formatted as yyyy-MM-dd 
    body: jsonEncode({
      'id': meal.id,
      'name': meal.name,
      'food_image_id': meal.foodImageId,
      'date': meal.date != null ? DateFormat('yyyy-MM-dd').format(meal.date!) : null,
      'ingredients': meal.ingredients.map((e) => e.toJson()).toList(),
    }) 
  );
  print('Statuscode: ${response.statusCode} body:${response.body}');
  return response; // Return the response from the server.
}

// Deletes a meal from the server by its ID.
// Takes an HTTP client and the meal ID as parameters.
// Returns the server's response after attempting to delete the meal.
Future<http.Response> deleteMeal(
    http.Client client, AuthProvider authProvider, int id) async {
  final jwtToken = await authProvider.retrieveToken();
  // Sending a DELETE request to the API endpoint to remove a meal by ID.
  final response = await client.delete(
    Uri.parse(
        '${ApiConfig.baseUrl}/api/Meals/Delete/$id'), // Specify the API endpoint for meal deletion.
    headers: <String, String>{
      'Content-Type':
          'application/json; charset=UTF-8', // Specify that the content is JSON.
      'Authorization': 'Bearer $jwtToken'
    },
  );
  return response; // Return the response from the server.
}
