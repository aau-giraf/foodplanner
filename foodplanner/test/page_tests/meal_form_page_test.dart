import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'meal_form_page_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final List<Ingredient> ingredients = [
    Ingredient(id: 0, name: 'æble', imageRef: null),
    Ingredient(id: 1, name: 'knækbrød', imageRef: 1),
    Ingredient(id: 2, name: 'franskbrød', imageRef: 2),
  ];
  final List<PackedIngredient> packedIngredients = [
    PackedIngredient(id: 0, mealRef: 0, ingredientRef: ingredients[0]),
    PackedIngredient(id: 1, mealRef: 0, ingredientRef: ingredients[1]),
    PackedIngredient(id: 2, mealRef: 0, ingredientRef: ingredients[2]),
  ];

  late bool cameraNavigated;
  late bool ingredientNavigated;
  late bool createdMeal;

  setUp(() {
    cameraNavigated = false;
    ingredientNavigated = false;
    createdMeal =  false;
  });
  
  MealFormPage createWidgetUnderTest() {
    return MealFormPage(
      ingredients: ingredients,
      packedIngredients: packedIngredients,
      mealTitleController: TextEditingController(),
      image: null,
      onAddIngredients: () => ingredientNavigated = true,
      onCamera: () async {
        cameraNavigated = true;
        print('Camera Navigated Set to True');
      },
      onCreateMeal: (client, title) async => createdMeal = true,
      client: MockClient(),
    );
  }
  
  group('MealFormPage ', () {
    group('contains widget: ', () {
      testWidgets('TextField prompt', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.text('Start med at give madpakken en titel'), findsOneWidget);
      });
      testWidgets('TextField to set the title of the meal"', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.byType(TextField), findsOneWidget);
      });
      testWidgets('Button prompt', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.text('Tilføj ingredienser'), findsOneWidget);
      });
      testWidgets('add ingredient button', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.byIcon(Icons.add), findsOneWidget);
      });
      testWidgets('create meal button', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.text('Opret madpakke'), findsOneWidget);
      });
    });
  });
  group('navigates to:', () {
    testWidgets('CameraPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest()),
      );

      await tester.tap(find.text('Opret madpakke'));
      await tester.pumpAndSettle();

      print('Button 1 tapped');

      await tester.tap(find.text('Ja'));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await Future.delayed(Duration(seconds: 1));
      });

      print('cameraNavigated: $cameraNavigated');
      
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