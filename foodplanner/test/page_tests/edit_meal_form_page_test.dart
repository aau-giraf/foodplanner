import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/components/edit_meal_element.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/pages/edit_meal_form_page.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'edit_meal_form_page_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final List<Ingredient> ingredients = [
    Ingredient(id: 0, name: 'æble', foodImageId: null),
    Ingredient(id: 1, name: 'knækbrød', foodImageId: 1),
    Ingredient(id: 2, name: 'franskbrød', foodImageId: 2),
  ];

  final List<PackedIngredient> packedIngredients = [
    PackedIngredient(id: 0, mealId: 0, orderNumber: 0, ingredient: ingredients[1]),
    PackedIngredient(id: 1, mealId: 1, orderNumber: 1, ingredient: ingredients[2])
  ];

  final Meal meal = Meal(
    id: 0,
    name: "meal",
    foodImageId: 0,
    date: DateTime.now(),
    ingredients: packedIngredients
  );

  late bool cameraNavigated;
  late bool ingredientNavigated;

  setUp(() {
    cameraNavigated = false;
    ingredientNavigated = false;
  });

  EditMealFormPage createWidgetUnderTest() {
    return EditMealFormPage(
      meal: meal,
      packedIngredients: packedIngredients,
      ingredients: ingredients,
      onAddIngredients: () => ingredientNavigated = true,
      onCamera: () => cameraNavigated = true,
      client: MockClient(),
      image: null,
    );
  }
  group('EditMealFormPage ', () {
    group('contains widget: ', () {
      testWidgets('edit meal element', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.byType(EditMealElement), findsOneWidget);
      });
      
      testWidgets('add ingredient button', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.byIcon(Icons.add), findsOneWidget);
      });
      testWidgets('save changes button', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.text('Gem ændringer'), findsOneWidget);
      });
    });
  });

  group('navigates to:', () {
    testWidgets('CameraPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest()),
      );

      await tester.tap(find.text('Redigér billede'));
      await tester.pumpAndSettle();
      
      expect(cameraNavigated, isTrue);
    });
    testWidgets('AddIngredientPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest()),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(ingredientNavigated, isTrue);
    });
  });
}