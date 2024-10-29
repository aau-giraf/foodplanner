import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/pages/edit_meal_page.dart';
import 'package:foodplanner/pages/edit_meal_form_page.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';

// Can't be tested properly, since Meal can't be fetched.
void main() {
  group('EditMealPage Widget Tests', () {
    late Meal meal;
    late List<Ingredient> ingredients;

    // Initial setup before tests
    setUp(() {
      meal = Meal();
      ingredients = [Ingredient(name: "Knækbrød", userRef: 1), Ingredient(name: "Æble", userRef: 1)];
    });

    testWidgets('should display EditMealFormPage by default', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: EditMealPage(mealID: 1)));

      // Act
      await tester.pumpAndSettle();  // Ensure async state changes are complete

      // Assert
      expect(find.byType(EditMealFormPage), findsOneWidget);
    });

    testWidgets('should navigate to AddIngredientPage when onAddIngredients is called', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: EditMealPage(mealID: 1)));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.add)); // Simulate onAddIngredients callback
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AddIngredientPage), findsOneWidget);
    });

    testWidgets('should navigate to CameraPage when onCamera is called', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(home: EditMealPage(mealID: 1)));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.camera)); // Simulate onCamera callback
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CameraPage), findsOneWidget);
    });
  });
}