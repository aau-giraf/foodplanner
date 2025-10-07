import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/components/button.dart';
import 'meal_form_page_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final List<Ingredient> ingredients = [
    Ingredient(id: 0, name: 'æble', foodImageId: null),
    Ingredient(id: 1, name: 'knækbrød', foodImageId: 1),
    Ingredient(id: 2, name: 'franskbrød', foodImageId: 2),
  ];
  final List<PackedIngredient> packedIngredients = [
    PackedIngredient(id: 0, mealId: 0, ingredient: ingredients[0]),
    PackedIngredient(id: 1, mealId: 0, ingredient: ingredients[1]),
    PackedIngredient(id: 2, mealId: 0, ingredient: ingredients[2]),
  ];

  MealFormPage createWidgetUnderTest() {
    return MealFormPage(
    );
  }
  
  group('MealFormPage ', () {
    group('contains widget: ', () {
      testWidgets('TextField prompt', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.text('Navn på madpakke'), findsOneWidget);
      });
      testWidgets('Navn fx. "Rugbrød med ost og grønt"', (WidgetTester tester) async {
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
      //THIS TEST BELOW CHECKS IF THE ADD INGREDIENT BUTTON EXISTS BY LOOKING FOR THE ICON, BUT THERE CURRENTLY IS NO ICON SO IT ALWAYS FAILS,
      //THE TEST ABOVE ALSO LOOKS FOR THE SAME BUTTON, SO IT IS REDUNDANT
      // testWidgets('add ingredient button', (WidgetTester tester) async {
      //   await tester.pumpWidget(
      //     MaterialApp(home: createWidgetUnderTest()),
      //   );
      //   expect(find.byIcon(Icons.add), findsOneWidget);
      // });
      testWidgets('create meal button', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.text('Opret madpakke'), findsAtLeastNWidgets(1));
      });
    });
  });
  group('navigates to:', () {
    testWidgets('CameraPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest()),
      );

      await tester.tap(find.widgetWithText(CustomButton, 'Opret madpakke'));
      await tester.pumpAndSettle();

      // await tester.tap(find.text('Ja'));
      // await tester.pumpAndSettle();

      expect(find.text('Vil du tilføje et billede af madpakken?'), findsOneWidget);
    });

    testWidgets('AddIngredientPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest()),
      );

      await tester.tap(find.text('Tilføj ingredienser'));
      await tester.pumpAndSettle();

      expect(find.text('Her kan du tilføje ingredienser til din madpakke.\nDu kan tilføje ingredienser fra din egen liste eller tilføje nye ingredienser.'), findsOneWidget);

      await tester.tap(find.text('Tilføj'));
      await tester.pumpAndSettle();

      expect(find.text('Tilføj madvare'), findsOneWidget);

    });
  });
}