import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/user.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ingredient_test.mocks.dart';

@GenerateMocks([http.Client, User])
void main() {
  final ingredient = Ingredient(
    id: 0,
    userRef: 1,
    name: 'ingredient',
    imageUrl: 'https://via.placeholder.com/150',
  );
  final ingredient1 = Ingredient(
    id: 1,
    userRef: 1,
    name: 'ingredient1',
    imageUrl: 'https://via.placeholder.com/150',
  );
  final ingredient2 = Ingredient(
    id: 2,
    userRef: 1,
    name: 'ingredient2',
    imageUrl: 'https://via.placeholder.com/150',
  );
  group('Ingredient.fromJSON test',() {

  });
  group('IngredientServices tests',() {
    group('fetchIngredient tests', () {
      test('return an ingredient instance on a successful fetch call', () async {
        final client = MyMockClient();

        when(client
              .get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/${ingredient.id}')))
          .thenAnswer((_) async =>
              http.Response('{"id": ${ingredient.id}, "userRef": ${ingredient.userRef}, "name": "${ingredient.name}", "imageUrl": "${ingredient.imageUrl}"}', 200));

        expect(await fetchIngredient(client, ingredient.id), isA<Ingredient>());
      });
      test('throw an exception when encountering an error', () async {
        final client = MyMockClient();

        when(client
                .get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/${ingredient.id}')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(fetchIngredient(client, 0), throwsException);
      });
    });
    group('fetchIngredientsByUserID tests', () {
      test('return a list of ingredient instances on a successful fetch call', () async {
        final client = MyMockClient();
        when(client.get(any)).thenAnswer((_) async => http.Response('{"id": ${ingredient.id}, "userRef": ${ingredient.userRef}, "name": "${ingredient.name}", "imageUrl": "${ingredient.imageUrl}"}', 200));
        final user = MockUser();

        when(user.id).thenReturn(1);
        when(client
              .get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/${user.id}')))
          .thenAnswer((_) async =>
              http.Response('[{"id": ${ingredient.id}, "userRef": ${ingredient.userRef}, "name": "${ingredient.name}", "imageUrl": "${ingredient.imageUrl}"},{"id": ${ingredient1.id}, "userRef": ${ingredient1.userRef}, "name": "${ingredient1.name}", "imageUrl": "${ingredient1.imageUrl}"},{"id": ${ingredient2.id}, "userRef": ${ingredient2.userRef}, "name": "${ingredient2.name}", "imageUrl": "${ingredient2.imageUrl}"}]', 200));
              

        expect(await fetchIngredientsByUserID(client, user.id), isA<List<Ingredient>>());
      });
      test('throw an exception when encountering an error', () async {
        final client = MyMockClient();
        final user = MockUser();

        when(client
                .get(Uri.parse('http://127.0.0.1:80/api/Ingredients/Get/${user.id}')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(fetchIngredientsByUserID(client, 0), throwsException);
      });
    });
    group('createIngredient tests', () {
      test('return with 200 response when a meal is added to the database', () async {
        final client = MyMockClient();

        when(createIngredient(client, ingredient.name, ingredient.userRef, 'PLACEHOLDER'))
          .thenAnswer((_) async => http.Response('{id: ${ingredient.id}, "userRef": ${ingredient.userRef}, name: "${ingredient.name}", imageUrl: "${ingredient.imageUrl}"}', 200));
        final response = await createIngredient(client, ingredient.name, ingredient.userRef, 'PLACEHOLDER');

        expect(response.statusCode, 200);
      });
    });
    group('deleteIngredient tests', () {
      test('return with 200 response when an ingredient is removed from the database', () async{
        final client = MyMockClient();

        when(deleteIngredient(client, ingredient.id))
          .thenAnswer((_) async => http.Response('{id: ${ingredient.id}, name: "${ingredient.name}", imageUrl: "${ingredient.imageUrl}"}', 200));
        final response = await deleteIngredient(client, ingredient.id);

        expect(response.statusCode, 200);
      });
    });
  });
}