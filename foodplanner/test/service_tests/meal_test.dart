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
import 'package:intl/intl.dart';


// Custom mock AuthProvider for tests only
class MockAuthProvider extends AuthProvider {
  @override
  Future<String?> retrieveToken() async {
    return 'mocked_token_value';
  }
}

// it might look nicer if all "ingredient_id: "..."" are replaced with: "ingredient_id": ${jsonEncode(meal.ingredients[0].toJson())},
@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final ingredient1 = Ingredient(id: 1, name: 'ingredient1', foodImageId: 1);
  final ingredient2 = Ingredient(id: 2, name: 'ingredient2', foodImageId: 0);
  final packed1 = PackedIngredient(id: 0, ingredient: ingredient1);
  final packed2 = PackedIngredient(id: 1, ingredient: ingredient2,);
  final meal = Meal(id: 0, name: 'meal1', foodImageId: 0, date: DateTime.now(), ingredients: [packed1, packed2]);
  late AuthProvider authProvider;

  group('MealServices tests',() {
    setUp(() {
      // Use the custom MockAuthProvider for tests
      authProvider = MockAuthProvider();
    });
    group('fetchMeal tests', () {
      test('return a packed meal instance on a successful fetch call', () async {
        final client = MockClient();

        // Arrange: Set up the stub with image as a URL string
        when(client
            .get(Uri.parse('${ApiConfig.baseUrl}/api/Meals/Get/${meal.id}'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer mocked_token_value',
              }))
            .thenAnswer((_) async => http.Response(
            jsonEncode(
            {
              "id": meal.id,
              "name": meal.name,
              "food_image_id": meal.foodImageId,
              "date": meal.date?.toIso8601String(),
              "ingredients": [
                {
                  "id": meal.ingredients[0].id, 
                  "meal_id": meal.id,
                  "ingredient_id": 
                  {
                    "id": meal.ingredients[0].ingredient.id, 
                    "name": meal.ingredients[0].ingredient.name, 
                    "food_image_id": meal.ingredients[0].ingredient.foodImageId
                  },
                  "order_number": 0,
                },
                {
                  "id": meal.ingredients[1].id,
                  "meal_id":meal.id,
                  "ingredient_id": 
                  {
                    "id": meal.ingredients[1].ingredient.id, 
                    "name": meal.ingredients[1].ingredient.name,
                    "food_image_id": meal.ingredients[1].ingredient.foodImageId
                  },
                  "order_number": 1,
                }
              ]
          }), 200));
        expect(await fetchMeal(client, authProvider, meal.id), isA<Meal>());
      });


      test('throw an exception when encountering an error', () async {
        final client = MockClient();

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
      test('return with 201 response when a meal is added to the database', () async {
        final client = MockClient();
        // Arrange: Set up the stub to mock the post call
        when(client.post(
          Uri.parse('${ApiConfig.baseUrl}/api/Meals/Create'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
          encoding: anyNamed('encoding'),
        )).thenAnswer((_) async => http.Response('''
        {
          "id": ${meal.id}, 
          "title": "${meal.name}", 
          "food_image_id": ${meal.foodImageId}, 
          "user_ref": 1, 
          "date": "${meal.date?.toIso8601String()}", 
          "template": ${meal.template}
          "ingredients": [
            {
              "id": ${meal.ingredients[0].id}, 
              "ingredient_id": 
              {
                "id": ${meal.ingredients[0].ingredient.id}, 
                "name": "${meal.ingredients[0].ingredient.name}", 
                "food_image_id": "${meal.ingredients[0].ingredient.foodImageId}"}
              }, 
            {
              "id": ${meal.ingredients[1].id}, 
              "ingredient_id": 
              {
                "id": ${meal.ingredients[1].ingredient.id}, 
                "name": "${meal.ingredients[1].ingredient.name}",
                "food_image_id": "${meal.ingredients[1].ingredient.foodImageId}"
              }
            }
          ]
        }''', 201));
        
        final response = await createMeal(authProvider, meal.name,meal.template, meal.foodImageId, meal.date, client: client);

        expect(response.statusCode, 201);
      });
    });


    group('updateMeal tests', () {
      test('return with 200 response when a meal is updated in the database', () async {
        final client = MockClient();

        // Arrange: Set up the stub to return a 200 response
        when(client.put(
          Uri.parse('${ApiConfig.baseUrl}/api/Meals/Update/${meal.id}'), // Specify the API endpoint for meal creation.
          headers: {
            'Content-Type': 'application/json; charset=UTF-8', // Specify that the content is JSON.
            'Authorization': 'Bearer mocked_token_value',
          },
          body:jsonEncode({
            'id': meal.id,
            'name': meal.name,
            'food_image_id': meal.foodImageId,
            'date': meal.date != null ? DateFormat('yyyy-MM-dd').format(meal.date!) : null,
            'ingredients': meal.ingredients.map((e) => e.toJson()).toList(),
          }) ,
        )).thenAnswer((_) async => http.Response(
          jsonEncode({
            'id': meal.id,
            'title': meal.name,
            'food_image_id': meal.foodImageId,
            'date': meal.date?.toIso8601String(),
            'ingredients': meal.ingredients.map((ingredient) => {
              'id': ingredient.id,
              'ingredient_id': {
                'id': ingredient.ingredient.id,
                'name': ingredient.ingredient.name,
                'food_image_id': ingredient.ingredient.foodImageId,
              }
            }).toList(),
          }),
          200,
        ));
    
        final response = await updateMeal(client, authProvider, meal);

        expect(response.statusCode, 200);
      });
    });

    group('deleteMeal tests', () {
      test('return with 200 response when a meal is removed from the database', () async {
        final client = MockClient();

        // Arrange: Set up the stub to return a 200 response
        when(client.delete(
          Uri.parse('${ApiConfig.baseUrl}/api/Meals/Delete/${meal.id}'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'Authorization': 'Bearer mocked_token_value',
              }))
        .thenAnswer((_) async => http.Response(
          jsonEncode(
          {
            "id": meal.id,
            "name": meal.name,
            "food_image_id": meal.foodImageId,
            "date": meal.date?.toIso8601String(),
            "ingredients": [
            {
              "id": meal.ingredients[0].id, 
              "meal_id": meal.id, 
              "ingredient_id": 
                {
                  "id": meal.ingredients[0].ingredient.id, 
                  "name": meal.ingredients[0].ingredient.name, 
                  "food_image_id": meal.ingredients[0].ingredient.foodImageId
                },
              "order_number": 0,
            },
            {
              "id": meal.ingredients[1].id,
              "meal_id":meal.id,
              "ingredient_id": 
              {
                "id": meal.ingredients[1].ingredient.id, 
                "name": meal.ingredients[1].ingredient.name,
                "food_image_id": meal.ingredients[1].ingredient.foodImageId
              },
              "order_number": 1,
            }]
          }), 200));
        
        final response = await deleteMeal(client, authProvider, meal.id);
        expect(response.statusCode, 200);
      });
    });
  });
}