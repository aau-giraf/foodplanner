  import 'dart:convert';

  import 'package:flutter_test/flutter_test.dart';
  import 'package:foodplanner/models/ingredient.dart';
  import 'package:foodplanner/models/meal.dart';
  import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/services/api_config.dart';
  import 'package:foodplanner/services/meal_services.dart';
  import 'package:http/http.dart' as http;
  import 'package:mockito/annotations.dart';
  import 'package:mockito/mockito.dart';
  import 'meal_test.mocks.dart';

  @GenerateMocks([http.Client])
  void main() {
    final ingredient1 = Ingredient(
      id: 1,
      name: 'ingredient1',
      imageRef: 1,
    );
    final ingredient2 = Ingredient(
      id: 2,
      name: 'ingredient2',
      imageRef: 0,
    );
    final packed1 = PackedIngredient(
      id: 0,
      ingredientRef: ingredient1,
    );
    final packed2 = PackedIngredient(
      id: 1,
      ingredientRef: ingredient2,
    );
    final meal = Meal(
      id: 0,
      title: 'meal1',
      imageRef: 0,
      date: DateTime.now(),
      ingredients: [packed1, packed2],
    );

    group('Meal.fromJSON',() {

    });
    group('MealServices tests',() {
      group('fetchMeal tests', () {
        test('return a packed meal instance on a successful fetch call', () async {
          final client = MyMockClient();

          // Arrange: Set up the stub with image as a URL string
          when(client
              .get(Uri.parse('${ApiConfig.baseUrl}/api/Meals/Get/${meal.id}')))
              .thenAnswer((_) async => http.Response(
                  '{"id": ${meal.id}, "title": "${meal.title}", "image_ref": ${meal.imageRef}, "date": "${meal.date?.toIso8601String()}", "ingredients": [{"id": ${meal.ingredients[0].id}, "meal_ref": ${meal.ingredients[0].mealRef}, "ingredient_ref": {"id": ${meal.ingredients[0].ingredientRef.id}, "name": "${meal.ingredients[0].ingredientRef.name}", "image_ref": "${meal.ingredients[0].ingredientRef.imageRef}"}}, {"id": ${meal.ingredients[1].id}, "meal_ref": ${meal.ingredients[1].mealRef}, "ingredient_ref": {"id": ${meal.ingredients[1].ingredientRef.id}, "name": "${meal.ingredients[1].ingredientRef.name}", "image_ref": "${meal.ingredients[1].ingredientRef.imageRef}"}}]}',
                  200));

          // Act: Fetch the meal
          final fetchedMeal = await fetchMeal(client, meal.id);

          expect(fetchedMeal, isA<Meal>());
        });
        test('throw an exception when encountering an error', () async {
          final client = MyMockClient();

          when(client
              .get(Uri.parse('${ApiConfig.baseUrl}/api/Meals/Get/${meal.id}')))
              .thenAnswer((_) async => http.Response('Not Found', 404));

          expect(fetchMeal(client, meal.id), throwsException);
        });
      });
      group('createMeal tests', () {
        test('return with 200 response when a meal is added to the database', () async {
          final client = MyMockClient();

          // Arrange: Set up the stub to mock the post call
          when(client.post(
            Uri.parse('${ApiConfig.baseUrl}/api/Meals/Create'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: jsonEncode({
              'title': meal.title,
              'image': 'PLACEHOLDER',
              'date': meal.date?.toIso8601String(),  // Ensure DateTime is converted to string
              'ingredients': meal.ingredients.map((e) => e.toJson()).toList(),
            }),
          )).thenAnswer((_) async => http.Response(
            '{"id": ${meal.id}, "title": "${meal.title}", "image_ref": ${meal.imageRef}, "date": "${meal.date?.toIso8601String()}", "ingredients": [{"id": ${meal.ingredients[0].id}, "ingredient_ref": {"id": ${meal.ingredients[0].ingredientRef.id}, "name": "${meal.ingredients[0].ingredientRef.name}", "image_ref": "${meal.ingredients[0].ingredientRef.imageRef}"}}, {"id": ${meal.ingredients[1].id}, "ingredient_ref": {"id": ${meal.ingredients[1].ingredientRef.id}, "name": "${meal.ingredients[1].ingredientRef.name}", "image_ref": "${meal.ingredients[1].ingredientRef.imageRef}"}}]}',
            200));
          
          // when(client.post(
          //   any,
          //   body: anyNamed('body'),
          //   headers: anyNamed('headers'),
          // )).thenAnswer((_) async => http.Response(
          //   '{"id": ${meal.id}, "title": "${meal.title}", "image_ref": "${meal.image_ref}", "date": "${meal.date?.toIso8601String()}", "ingredients": [{"id": ${meal.ingredients[0].id}, "ingredient_ref": {"id": ${meal.ingredients[0].ingredient_ref.id}, "name": "${meal.ingredients[0].ingredient_ref.name}", "image": "${meal.ingredients[0].ingredient_ref.image_ref}"}}, {"id": ${meal.ingredients[1].id}, "ingredient_ref": {"id": ${meal.ingredients[1].ingredient_ref.id}, "name": "${meal.ingredients[1].ingredient_ref.name}", "image": "${meal.ingredients[1].ingredient_ref.image_ref}"}}]}',
          //   200));
          // when(createMeal(client, meal.title, 'PLACEHOLDER', meal.date, meal.ingredients))
          //   .thenAnswer((_) async => http.Response('id: ${meal.id}, title: ${meal.title}, image_ref: ${meal.image_ref}, date: ${meal.date}, ingredients: [{id: ${meal.ingredients[1].id}, mealRef: , ingredient_ref: {id: ${meal.ingredients[1].ingredient_ref.id}, name: ${meal.ingredients[1].ingredient_ref.name}, image: ${meal.ingredients[1].ingredient_ref.image_ref}},{id: ${meal.ingredients[1].id}, mealRef: , ingredient_ref: {id: ${meal.ingredients[2].ingredient_ref.id}, name: ${meal.ingredients[2].ingredient_ref.name}, image_ref:  ${meal.ingredients[2].ingredient_ref.image_ref}}}]', 200));
          final response = await createMeal(client, meal.title, 0, meal.date, meal.ingredients);

          expect(response.statusCode, 200);
        });
      });
      group('deleteMeal tests', () {
        test('return with 200 response when a meal is removed from the database', () async {
          final client = MyMockClient();

          // Arrange: Set up the stub to return a 200 response
          when(client.delete(
            Uri.parse('${ApiConfig.baseUrl}/api/Meals/Delete/${meal.id}'),
            headers: anyNamed('headers'),
          )).thenAnswer((_) async => http.Response('Success', 200));
          // when(deleteMeal(client, meal.id))
          //   .thenAnswer((_) async => http.Response('id: ${meal.id}, title: ${meal.title}, image_ref: ${meal.image_ref}, date: ${meal.date}, ingredients: [{id: ${meal.ingredients[1].id}, mealRef: , ingredient_ref: {id: ${meal.ingredients[1].ingredient_ref.id}, name: ${meal.ingredients[1].ingredient_ref.name}, image: ${meal.ingredients[1].ingredient_ref.image_ref}},{id: ${meal.ingredients[1].id}, mealRef: , ingredient_ref: {id: ${meal.ingredients[2].ingredient_ref.id}, name: ${meal.ingredients[2].ingredient_ref.name}, image_ref: ${meal.ingredients[2].ingredient_ref.image_ref}}}]', 200));
          final response = await deleteMeal(client, meal.id);

          expect(response.statusCode, 200);
        });
      });
    });
  }