import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/services/packed_ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'packed_ingredient_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final ingredient = Ingredient(
    id: 0,
    userRef: 1,
    name: 'ingredient',
    imageUrl: 'https://via.placeholder.com/150',
  );
  final packed = PackedIngredient(
    id: 0,
    mealRef: 0,
    ingredientRef: ingredient,
  );
  group('PackedIngredient.fromJSON test',() {

  });
  group('PackedIngredientServices tests',() {
    group('fetchPackedIngredient tests', () {
      test('return a packed ingredient instance on a successful fetch call', () async {
        final client = MyMockClient();
        
        // Arrange: Set up the stub
        when(client.get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/${packed.id}')))
            .thenAnswer((_) async => http.Response(
                '{ "id": ${packed.id}, "mealRef": ${packed.mealRef}, "ingredientRef": { "id": ${packed.ingredientRef.id}, "userRef": ${packed.ingredientRef.userRef}, "name": "${packed.ingredientRef.name}", "image": "https://via.placeholder.com/150" }}', 200));

        expect(await fetchPackedIngredient(client, packed.id), isA<PackedIngredient>());
      });
      test('throw an exception when encountering an error', () async {
        final client = MyMockClient();

        when(client
                .get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/${packed.id}')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(fetchPackedIngredient(client, packed.id), throwsException);
      });
    });
    group('createPackedIngredient tests', () {
      test('return with 200 response when a packed ingredient is added to the database', () async {
        final client = MyMockClient();
        
        when(createPackedIngredient(client, packed.mealRef, packed.ingredientRef, packed.id))
          .thenAnswer((_) async => http.Response('{"id": ${packed.id}, "mealRef": ${packed.mealRef}, "ingredientRef": {"id": ${packed.ingredientRef.id}, "userRef": ${packed.ingredientRef.userRef}, "name": ${packed.ingredientRef.name}, "imageUrl": ${packed.ingredientRef.imageUrl}}}', 200));
        
        final response = await createPackedIngredient(client, packed.mealRef, packed.ingredientRef, packed.id);

        expect(response.statusCode, 200);
      });
    });
    group('deletePackedIngredient tests', () {
      test('return with 200 response when a packed ingredient is removed from the database', () async {
        final client = MyMockClient();

        when(deletePackedIngredient(client, packed.id))
          .thenAnswer((_) async => http.Response('{"id": ${packed.id}, "mealRef": ${packed.mealRef}, "ingredientRef": {"id": ${packed.ingredientRef.id}, "userRef": ${packed.ingredientRef.userRef}, "name": ${packed.ingredientRef.name}, "imageUrl": ${packed.ingredientRef.imageUrl}}}', 200));
        
        final response = await deletePackedIngredient(client, packed.id);
        
        expect(response.statusCode, 200);
      });
    });
  });
}