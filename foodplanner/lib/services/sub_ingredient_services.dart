import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/sub_ingredient.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/services/api_config.dart';

class SubIngredientServices {
  final String apiUrl;

  SubIngredientServices({required this.apiUrl});

  // Fetch all sub-ingredients
  Future<List<SubIngredient>> getAllSubIngredients(
      AuthProvider authProvider, {http.Client? client}) async {
        
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredients/GetAll'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Kunne ikke hente underingredienser');
    }

    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse
        .map((json) => SubIngredient.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Fetch all sub-ingredients by user
  Future<List<SubIngredient>> getAllSubIngredientsByUser(
      AuthProvider authProvider, {http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredients/GetAllByUser'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Kunne ikke hente underingredienser');
    }

    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse
        .map((json) => SubIngredient.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Fetch a sub-ingredient by ID
  Future<SubIngredient> getSubIngredient(
      AuthProvider authProvider, int id, {http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredients/Get/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Kunne ikke hente underingrediens');
    }

    return SubIngredient.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // Create a new sub-ingredient
  Future<http.Response> createSubIngredient(
      AuthProvider authProvider, SubIngredient subIngredient, {http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();
  
    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredients/Create'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'name': subIngredient.name,
        // 'food_image_id': subIngredient.foodImageId

      }),
    );

    return response;
  }

  // Update a sub-ingredient
  Future<http.Response> updateSubIngredient(
      AuthProvider authProvider, SubIngredient subIngredient, {http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.put(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredients/Update/${subIngredient.id}'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'name': subIngredient.name,
        "user_id": subIngredient.name,
  "food_image_id": subIngredient.name
      }),
    );

    return response;
  }

  // Delete a sub-ingredient
  Future<http.Response> deleteSubIngredient(
      AuthProvider authProvider, int id, {http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredients/Delete/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    return response;
  }
}


