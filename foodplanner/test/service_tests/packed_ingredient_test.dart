import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/packed_ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'packed_ingredient_test.mocks.dart';

// Custom mock AuthProvider for tests only
class MockAuthProvider extends AuthProvider {
  @override
  Future<String?> retrieveToken() async {
    return 'mocked_token_value';
  }
}

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final ingredient = Ingredient(id: 0, name: 'ingredient', imageRef: 0);
  final packed = PackedIngredient(mealRef: 0, ingredientRef: ingredient);

  late AuthProvider authProvider;

  group('PackedIngredientServices tests',() {
    setUp(() {
      // Use the custom MockAuthProvider for tests
      authProvider = MockAuthProvider();
    });

    group('fetchPackedIngredient tests', () {
      test('return a packed ingredient instance on a successful fetch call', () async {
        final client = MyMockClient();

        // Arrange: Set up the stub for GET
        when(client.get(
          Uri.parse('${ApiConfig.baseUrl}/api/PackedIngredient/Get/${packed.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer mocked_token_value',
          }))
        .thenAnswer((_) async => http.Response(
          '{ "id": ${packed.id}, "meal_ref": ${packed.mealRef}, "ingredient_ref": { "id": ${packed.ingredientRef.id}, "name": "${packed.ingredientRef.name}", "image_ref": ${packed.ingredientRef.imageRef}}}', 200));

        expect(await fetchPackedIngredient(client, authProvider, packed.id), isA<PackedIngredient>());
      });

      test('throw an exception when encountering an error', () async {
        final client = MyMockClient();

        // Arrange: Set up the stub for GET to simulate failure (404)
        when(client.get(
          Uri.parse('${ApiConfig.baseUrl}/api/PackedIngredient/Get/${packed.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer mocked_token_value',
          }))
        .thenAnswer((_) async => http.Response('Not Found', 404));

        // Expect that an exception is thrown when the call is made
        expect(fetchPackedIngredient(client, authProvider, packed.id), throwsException);
      });
    });

    group('createPackedIngredient tests', () {
      test('return with 201 response when a packed ingredient is added to the database', () async {
        final client = MyMockClient();

        // Arrange: Set up the stub for POST
        when(client.post(
          Uri.parse('${ApiConfig.baseUrl}/api/PackedIngredient/Create'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer mocked_token_value',
          },
          body: jsonEncode({
            'meal_ref': packed.mealRef,
            'ingredient_ref': packed.ingredientRef.id,
          }),
        ))
        .thenAnswer((_) async => http.Response(
          '{"id": ${packed.id}, "meal_ref": ${packed.mealRef}, "ingredient_ref": ${packed.ingredientRef.id}}', 201));

        final response = await createPackedIngredient(client, authProvider, packed.mealRef, packed.ingredientRef.id);
        
        expect(response.statusCode, 201);
      });
    });

    group('deletePackedIngredient tests', () {
      test('return with 200 response when a packed ingredient is removed from the database', () async {
        final client = MyMockClient();

        // Arrange: Set up the stub for DELETE
        when(client.delete(
          Uri.parse('${ApiConfig.baseUrl}/api/PackedIngredient/Delete/${packed.id}'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer mocked_token_value',
          }))
        .thenAnswer((_) async => http.Response(
          '{"id": ${packed.id}, "meal_ref": ${packed.mealRef}, "ingredient_ref": {"id": ${packed.ingredientRef.id}, "name": "${packed.ingredientRef.name}", "image_ref": ${packed.ingredientRef.imageRef}}}', 200));

        final response = await deletePackedIngredient(client, authProvider, packed.id);

        expect(response.statusCode, 200);
      });
    });
  });
}