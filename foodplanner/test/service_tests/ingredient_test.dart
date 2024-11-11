import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:foodplanner/auth/auth_provider.dart';

import 'ingredient_test.mocks.dart';

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
  final ingredient1 = Ingredient(id: 1, name: 'ingredient1', imageRef: 1);
  final ingredient2 = Ingredient(id: 2, name: 'ingredient2', imageRef: 2);

  late AuthProvider authProvider;

  group('IngredientServices tests', () {
    setUp(() {
      // Use the custom MockAuthProvider for tests
      authProvider = MockAuthProvider();
    });

    group('fetchIngredient tests', () {
      test('returns an Ingredient instance on a successful fetch call', () async {
        final client = MyMockClient();

        // Mock the HTTP GET request response
        when(client.get(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Get/${ingredient.id}'),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer mocked_token_value',
                }))
            .thenAnswer((_) async => http.Response(
                '{"id": ${ingredient.id}, "name": "${ingredient.name}", "image_ref": ${ingredient.imageRef}}', 200));

        // Pass the mock AuthProvider explicitly
        expect(await fetchIngredient(client, authProvider, ingredient.id), isA<Ingredient>());
      });

      test('throws an exception when encountering an error', () async {
        final client = MyMockClient();

        // Mock an unsuccessful HTTP GET request
        when(client.get(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Get/${ingredient.id}'),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer mocked_token_value',
                }))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        // Expect fetchIngredient to throw an exception
        expect(() => fetchIngredient(client, authProvider, 0), throwsException);
      });
    });

    group('fetchIngredientsByUserID tests', () {
      test('returns a list of Ingredient instances on a successful fetch call', () async {
        final client = MyMockClient();

        when(client.get(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/GetAllByUser'),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer mocked_token_value',
                }))
            .thenAnswer((_) async => http.Response(
                '[{"id": ${ingredient.id}, "name": "${ingredient.name}", "image_ref": ${ingredient.imageRef}},'
                '{"id": ${ingredient1.id}, "name": "${ingredient1.name}", "image_ref": ${ingredient1.imageRef}},'
                '{"id": ${ingredient2.id}, "name": "${ingredient2.name}", "image_ref": ${ingredient2.imageRef}}]', 200));

        // Expect fetchIngredientsByUserID to return a List of Ingredients
        expect(await fetchIngredientsByUserID(client, authProvider), isA<List<Ingredient>>());
      });

      test('throws an exception when encountering an error', () async {
        final client = MyMockClient();

        // Mock an unsuccessful HTTP GET request
        when(client.get(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/GetAllByUser'),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer mocked_token_value',
                }))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        // Expect fetchIngredientsByUserID to throw an exception
        expect(() => fetchIngredientsByUserID(client, authProvider), throwsException);
      });
    });

    group('createIngredient tests', () {
      test('returns with 201 response when a meal is added to the database', () async {
        final client = MyMockClient();

        // Mock the POST request response
        when(client.post(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Create'),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer mocked_token_value',
                },
                body: jsonEncode({'name': ingredient.name, 'image_ref': ingredient.imageRef.toString()})))
            .thenAnswer((_) async => http.Response(
                '{"id": ${ingredient.id}, "name": "${ingredient.name}", "image_ref": ${ingredient.imageRef}}', 201));

        final response = await createIngredient(client, authProvider, ingredient.name, ingredient.imageRef);

        expect(response.statusCode, 201);
      });
    });

    group('deleteIngredient tests', () {
      test('returns with 200 response when an ingredient is removed from the database', () async {
        final client = MyMockClient();

        // Mock the DELETE request response
        when(client.delete(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Delete/${ingredient.id}'),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer mocked_token_value',
                }))
            .thenAnswer((_) async => http.Response(
                '{"id": ${ingredient.id}, "name": "${ingredient.name}", "image_ref": ${ingredient.imageRef}}', 200));

        final response = await deleteIngredient(client, authProvider, ingredient.id);

        expect(response.statusCode, 200);
      });
    });
  });
}