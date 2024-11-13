  import 'dart:convert';
  import 'package:flutter_test/flutter_test.dart';
  import 'package:foodplanner/auth/auth_provider.dart';
  import 'package:foodplanner/models/ingredient.dart';
  import 'package:foodplanner/models/meal.dart';
  import 'package:foodplanner/models/packed_ingredient.dart';
  import 'package:foodplanner/services/api_config.dart';
  import 'package:foodplanner/services/meal_services.dart';
  import 'package:http/http.dart' as http;
  import 'package:mockito/annotations.dart';
  import 'package:mockito/mockito.dart';
  import 'meal_test.mocks.dart';

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

    final ingredient1 = Ingredient(id: 1, name: 'ingredient1', imageRef: 1);
    final ingredient2 = Ingredient(id: 2, name: 'ingredient2', imageRef: 0);
    final packed1 = PackedIngredient(id: 0, ingredientRef: ingredient1);
    final packed2 = PackedIngredient(id: 1, ingredientRef: ingredient2,);
    final meal = Meal(id: 0, title: 'meal1', imageRef: 0, date: DateTime.now(), ingredients: [packed1, packed2]);

    late AuthProvider authProvider;

    group('MealServices tests',() {
      setUp(() {
        // Use the custom MockAuthProvider for tests
        authProvider = MockAuthProvider();
      });
      group('fetchMeal tests', () {
        test('return a packed meal instance on a successful fetch call', () async {
          final client = MyMockClient();

          // Arrange: Set up the stub with image as a URL string
          when(client
              .get(Uri.parse('${ApiConfig.baseUrl}/api/Meals/Get/${meal.id}'),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer mocked_token_value',
                }))
              .thenAnswer((_) async => http.Response(
                  '{"id": ${meal.id}, "title": "${meal.title}", "image_ref": ${meal.imageRef}, "date": "${meal.date?.toIso8601String()}", "ingredients": [{"id": ${meal.ingredients[0].id}, "meal_ref": ${meal.ingredients[0].mealRef}, "ingredient_ref": {"id": ${meal.ingredients[0].ingredientRef.id}, "name": "${meal.ingredients[0].ingredientRef.name}", "image_ref": ${meal.ingredients[0].ingredientRef.imageRef}}}, {"id": ${meal.ingredients[1].id}, "meal_ref": ${meal.ingredients[1].mealRef}, "ingredient_ref": {"id": ${meal.ingredients[1].ingredientRef.id}, "name": "${meal.ingredients[1].ingredientRef.name}", "image_ref": "${meal.ingredients[1].ingredientRef.imageRef}"}}]}',
                  200));

          expect(await fetchMeal(client, authProvider, meal.id), isA<Meal>());
        });
        test('throw an exception when encountering an error', () async {
          final client = MyMockClient();

          when(client
              .get(Uri.parse('${ApiConfig.baseUrl}/api/Meals/Get/${meal.id}'),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer mocked_token_value',
                }))
              .thenAnswer((_) async => http.Response('Not Found', 404));

          expect(fetchMeal(client, authProvider, meal.id), throwsException);
        });
      });
      group('createMeal tests', () {
        test('return with 200 response when a meal is added to the database', () async {
          final client = MyMockClient();

          // Arrange: Set up the stub to mock the post call
          when(client.post(
            Uri.parse('${ApiConfig.baseUrl}/api/Meals/Create'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer mocked_token_value',
            },
            body: jsonEncode({
              'id': 0,
              'title': meal.title,
              'image_ref': meal.imageRef,
              'date': meal.date?.toIso8601String(),
            }),
          )).thenAnswer((_) async => http.Response(
            '{"id": ${meal.id}, "title": "${meal.title}", "image_ref": ${meal.imageRef}, "user_ref": 1, "date": "${meal.date?.toIso8601String()}", "ingredients": [{"id": ${meal.ingredients[0].id}, "ingredient_ref": {"id": ${meal.ingredients[0].ingredientRef.id}, "name": "${meal.ingredients[0].ingredientRef.name}", "image_ref": "${meal.ingredients[0].ingredientRef.imageRef}"}}, {"id": ${meal.ingredients[1].id}, "ingredient_ref": {"id": ${meal.ingredients[1].ingredientRef.id}, "name": "${meal.ingredients[1].ingredientRef.name}", "image_ref": "${meal.ingredients[1].ingredientRef.imageRef}"}}]}',
            201));
          
          final response = await createMeal(client, authProvider, meal.title, meal.imageRef, meal.date);

          expect(response.statusCode, 201);
        });
      });
      group('updateMeal tests', () {
        test('return with 200 response when a meal is updated in the database', () async {
          final client = MyMockClient();

          // Arrange: Set up the stub to return a 200 response
          when(client.put(
            Uri.parse('${ApiConfig.baseUrl}/api/Meals/Update/${meal.id}'), // Specify the API endpoint for meal creation.
            headers: {
              'Content-Type': 'application/json; charset=UTF-8', // Specify that the content is JSON.
              'Authorization': 'Bearer mocked_token_value',
            },
            body: jsonEncode(meal.toJson()),
          )).thenAnswer((_) async => http.Response(
            jsonEncode({
              'id': meal.id,
              'title': meal.title,
              'image_ref': meal.imageRef,
              'date': meal.date?.toIso8601String(),
              'ingredients': meal.ingredients.map((ingredient) => {
                'id': ingredient.id,
                'ingredient_ref': {
                  'id': ingredient.ingredientRef.id,
                  'name': ingredient.ingredientRef.name,
                  'image_ref': ingredient.ingredientRef.imageRef,
                }
              }).toList(),
            }),
            200,
          ));
            // '{"id": ${meal.id}, "title": "${meal.title}", "image_ref": ${meal.imageRef}, "date": "${meal.date?.toIso8601String()}", "ingredients": [{"id": ${meal.ingredients[0].id}, "ingredient_ref": {"id": ${meal.ingredients[0].ingredientRef.id}, "name": "${meal.ingredients[0].ingredientRef.name}", "image_ref": "${meal.ingredients[0].ingredientRef.imageRef}"}}, {"id": ${meal.ingredients[1].id}, "ingredient_ref": {"id": ${meal.ingredients[1].ingredientRef.id}, "name": "${meal.ingredients[1].ingredientRef.name}", "image_ref": "${meal.ingredients[1].ingredientRef.imageRef}"}}]}',
            // 200));
          
          final response = await updateMeal(client, authProvider, meal);

          expect(response.statusCode, 200);
        });
      });
      group('deleteMeal tests', () {
        test('return with 200 response when a meal is removed from the database', () async {
          final client = MyMockClient();

          // Arrange: Set up the stub to return a 200 response
          when(client.delete(
            Uri.parse('${ApiConfig.baseUrl}/api/Meals/Delete/${meal.id}'),
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer mocked_token_value',
                }))
          .thenAnswer((_) async => http.Response(
            '{"id": ${meal.id}, "title": "${meal.title}", "image_ref": ${meal.imageRef}, "date": "${meal.date?.toIso8601String()}", "ingredients": [{"id": ${meal.ingredients[0].id}, "ingredient_ref": {"id": ${meal.ingredients[0].ingredientRef.id}, "name": "${meal.ingredients[0].ingredientRef.name}", "image_ref": "${meal.ingredients[0].ingredientRef.imageRef}"}}, {"id": ${meal.ingredients[1].id}, "ingredient_ref": {"id": ${meal.ingredients[1].ingredientRef.id}, "name": "${meal.ingredients[1].ingredientRef.name}", "image_ref": "${meal.ingredients[1].ingredientRef.imageRef}"}}]}',
          200));
          
          final response = await deleteMeal(client, authProvider, meal.id);

          expect(response.statusCode, 200);
        });
      });
    });
  }