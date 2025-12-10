import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/sub_ingredient_relation.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/services/api_config.dart';

class SubIngredientRelationServices {
  final String apiUrl;
  
  SubIngredientRelationServices({required this.apiUrl});

  // Fetch all sub-ingredient relations
  Future<List<SubIngredientRelation>> getAllSubIngredientRelations(
      AuthProvider authProvider, {http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredientRelation/GetAll'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Kunne ikke hente underingrediens relationer');
    }

    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse
        .map((json) =>
            SubIngredientRelation.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Fetch sub-ingredient relations by ingredient ID
  Future<List<SubIngredientRelation>> getSubIngByIngId(
      AuthProvider authProvider, int ingredientId, {http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.get(
      Uri.parse(
          '${ApiConfig.baseUrl}/api/SubIngredientRelation/GetByIngredientId/$ingredientId'),
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
        .map((json) =>
            SubIngredientRelation.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Fetch a sub-ingredient relation by ID
  Future<SubIngredientRelation> getSubIngredientRelation(
      AuthProvider authProvider, int id, {http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.get(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredientRelation/Get/relation/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Kunne ikke hente underingrediens relation');
    }

    return SubIngredientRelation.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }

  // Create a new sub-ingredient relation
  Future<http.Response> createSubIngredientRelation(
      AuthProvider authProvider,
      int ingredientId,
      int subIngredientId,
      {int? orderNumber, http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.post(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredientRelation/Create'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'ingredient_id': ingredientId,
        'subingredient_id': subIngredientId,
        if (orderNumber != null) 'order_number': orderNumber,
      }),
    );

    return response;
  }

  // Update a sub-ingredient relation
  Future<http.Response> updateSubIngredientRelation(
      AuthProvider authProvider,
      int id,
      int ingredientId,
      int subIngredientId,
      {int? orderNumber, http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.put(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredientRelation/Update/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'ingredient_id': ingredientId,
        'subingredient_id': subIngredientId,
        if (orderNumber != null) 'order_number': orderNumber,
      }),
    );

    return response;
  }

  // Delete a sub-ingredient relation
  Future<http.Response> deleteSubIngredientRelation(
      AuthProvider authProvider, int id, {http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredientRelation/Delete/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    return response;
  }

  // Update order of sub-ingredient relations
  Future<http.Response> updateSubIngredientRelationOrder(
      AuthProvider authProvider, List<Map<String, dynamic>> relations,
      {http.Client? client}) async {
    client ??= http.Client();
    final jwtToken = await authProvider.retrieveToken();

    final response = await client.put(
      Uri.parse('${ApiConfig.baseUrl}/api/SubIngredientRelation/UpdateOrder'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(relations),
    );

    return response;
  }
}


