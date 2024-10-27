import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/pages/edit_meal_page.dart';
import 'package:foodplanner/pages/edit_meal_form_page.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/cameraPage.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:mockito/mockito.dart';

// Can't be tested properly, since Meal can't be fetched.

void main() {
  group('EditMealPage Widget Tests', () {
    late Meal meal;
    late List<Ingredient> ingredients;

    setUp(() {
      meal = Meal();
      ingredients = [Ingredient(name: "Knækbrød"), Ingredient(name: "Æble")];
    });

    testWidgets('should display EditMealFormPage by default', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: EditMealPage(mealID: 1)));
      await tester.pumpAndSettle();  // Ensure async state changes are complete
      expect(find.byType(EditMealFormPage), findsOneWidget);
    });

    testWidgets('should navigate to AddIngredientPage when onAddIngredients is called', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: EditMealPage(mealID: 1)));
      await tester.pumpAndSettle();

      // Simulate onAddIngredients callback
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.byType(AddIngredientPage), findsOneWidget);
    });

    testWidgets('should navigate to CameraPage when onCamera is called', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: EditMealPage(mealID: 1)));
      await tester.pumpAndSettle();

      // Simulate onCamera callback
      await tester.tap(find.byIcon(Icons.camera));
      await tester.pumpAndSettle();
      expect(find.byType(CameraPage), findsOneWidget);
    });
  });
}