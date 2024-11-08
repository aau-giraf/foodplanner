import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ingredient_test.mocks.dart';

@GenerateMocks([http.Client, User])
void main() {
  final ingredient = Ingredient(
    id: 0,
    name: 'ingredient',
    imageRef: 0,
  );
  final ingredient1 = Ingredient(
    id: 1,
    name: 'ingredient1',
    imageRef: 1,
  );
  final ingredient2 = Ingredient(
    id: 2,
    name: 'ingredient2',
    imageRef: 2,
  );
  group('Ingredient.fromJSON test',() {

  });
  group('IngredientServices tests',() {
    group('fetchIngredient tests', () {
      test('return an ingredient instance on a successful fetch call', () async {
        final client = MyMockClient();

        when(client
              .get(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Get/${ingredient.id}')))
          .thenAnswer((_) async =>
              http.Response('{"id": ${ingredient.id}, "name": "${ingredient.name}", "image_ref": ${ingredient.imageRef}}', 200));

        expect(await fetchIngredient(client, ingredient.id), isA<Ingredient>());
      });
      test('throw an exception when encountering an error', () async {
        final client = MyMockClient();

        when(client
                .get(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Get/${ingredient.id}')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(fetchIngredient(client, 0), throwsException);
      });
    });
    group('fetchIngredientsByUserID tests', () {
      test('return a list of ingredient instances on a successful fetch call', () async {
        final client = MyMockClient();
        when(client.get(any)).thenAnswer((_) async => http.Response('{"id": ${ingredient.id}, "name": "${ingredient.name}", "image_ref": ${ingredient.imageRef}}', 200));
        final user = MockUser();

        when(user.id).thenReturn(1);
        when(client
              .get(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Get/${user.id}')))
          .thenAnswer((_) async =>
              http.Response('[{"id": ${ingredient.id}, "name": "${ingredient.name}", "image_ref": ${ingredient.imageRef}},{"id": ${ingredient1.id}, "name": "${ingredient1.name}", "image_ref": ${ingredient1.imageRef}},{"id": ${ingredient2.id}, "name": "${ingredient2.name}", "image_ref": ${ingredient2.imageRef}}]', 200));
              

        expect(await fetchIngredientsByUserID(client), isA<List<Ingredient>>());
      });
      test('throw an exception when encountering an error', () async {
        final client = MyMockClient();
        final user = MockUser();

        when(client
                .get(Uri.parse('${ApiConfig.baseUrl}/api/Ingredients/Get/${user.id}')))
            .thenAnswer((_) async => http.Response('Not Found', 404));

        expect(fetchIngredientsByUserID(client), throwsException);
      });
    });
    group('createIngredient tests', () {
      test('return with 200 response when a meal is added to the database', () async {
        final client = MyMockClient();

        when(createIngredient(client, ingredient.name, ingredient.imageRef))
          .thenAnswer((_) async => http.Response('{id: ${ingredient.id}, name: "${ingredient.name}", image_ref: ${ingredient.imageRef}}', 200));
        final response = await createIngredient(client, ingredient.name, ingredient.imageRef);

        expect(response.statusCode, 200);
      });
    });
    group('deleteIngredient tests', () {
      test('return with 200 response when an ingredient is removed from the database', () async{
        final client = MyMockClient();

        when(deleteIngredient(client, ingredient.id))
          .thenAnswer((_) async => http.Response('{id: ${ingredient.id}, name: "${ingredient.name}", image_ref: ${ingredient.imageRef}}', 200));
        final response = await deleteIngredient(client, ingredient.id);

        expect(response.statusCode, 200);
      });
    });
  });
}