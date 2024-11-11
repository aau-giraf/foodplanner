import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/components/meal_list_element.dart';
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
    Ingredient(id: 0, name: 'æble', imageRef: null),
    Ingredient(id: 1, name: 'knækbrød', imageRef: 1),
    Ingredient(id: 2, name: 'franskbrød', imageRef: 2),
  ];

  final Meal meal = Meal(
    id: 1,
    title: 'meal1',
    imageRef: 0,
    date: DateTime.now(),
    ingredients: [
      PackedIngredient(id: 0, mealRef: 1, ingredientRef: ingredients[1]),
      PackedIngredient(id: 0, mealRef: 1, ingredientRef: ingredients[2])
    ]);

  late bool cameraNavigated;
  late bool ingredientNavigated;

  setUp(() {
    cameraNavigated = false;
    ingredientNavigated = false;
  });

  EditMealFormPage createWidgetUnderTest() {
    return EditMealFormPage(
      meal: meal,
      ingredients: ingredients,
      onAddIngredients: () => ingredientNavigated = true,
      onCamera: () => cameraNavigated = true,
      client: MockClient(),
    );
  }
  group('EditMealFormPage ', () {
    group('contains widget: ', () {
      testWidgets('Meal element"', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.byType(MealListElement), findsOneWidget);
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

      await tester.tap(find.text('Gem ændringer'));
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