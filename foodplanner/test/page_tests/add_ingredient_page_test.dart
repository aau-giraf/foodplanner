import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';

void main() {
  group('AddIngredientPage widget tests', () {
    group('AddIngredientPage AppBar Tests', () {
      testWidgets('should display the correct title', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(meal: meal, ingredients: ingredients, onCamera: () {}),
        ));

        // Assert
        expect(find.text("Find madvare"), findsOneWidget);
      });

      testWidgets('should not display incorrect title', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(meal: meal, ingredients: ingredients, onCamera: () {}),
        ));

        // Assert
        expect(find.text("Incorrect Title"), findsNothing); // Incorrect title should not be found
      });
    });

    group('AddIngredientPage Ingredient List Tests', () {
      testWidgets('should display ingredients', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [
          Ingredient(userRef: 1, name: 'Tomato'),
          Ingredient(userRef: 1, name: 'Lettuce')
        ];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(meal: meal, ingredients: ingredients, onCamera: () {}),
        ));

        // Assert
        expect(find.text('Tomato'), findsOneWidget);
        expect(find.text('Lettuce'), findsOneWidget);
      });

      testWidgets('should display no ingredients', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(meal: meal, ingredients: ingredients, onCamera: () {}),
        ));

        // Assert
        expect(find.text('Tomato'), findsNothing);
      });

      testWidgets('should not display non-existent ingredient', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [
          Ingredient(userRef: 1, name: 'Tomato'),
          Ingredient(userRef: 1, name: 'Lettuce')
        ];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(meal: meal, ingredients: ingredients, onCamera: () {}),
        ));

        // Assert
        expect(find.text('Cucumber'), findsNothing); // Non-existent ingredient should not be found
      });
    });

    // These tests do not work, because of fetching not being fully implemented
    group('AddIngredientPage Search Functionality Tests', () {
      testWidgets('should filter ingredients based on search input', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [
          Ingredient(userRef: 1, name: 'Tomato'),
          Ingredient(userRef: 1, name: 'Lettuce'),
          Ingredient(userRef: 1, name: 'Cucumber')
        ];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(meal: meal, ingredients: ingredients, onCamera: () {}),
        ));

        // Act
        await tester.enterText(find.byType(TextField), 'to');
        await tester.pump(); // Rebuild the widget

        // Assert
        expect(find.text('Tomato'), findsOneWidget);
        expect(find.text('Lettuce'), findsNothing);
        expect(find.text('Cucumber'), findsNothing);
      });

      testWidgets('should not display ingredient if search is incorrect', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [
          Ingredient(userRef: 1, name: 'Tomato'),
          Ingredient(userRef: 1, name: 'Lettuce'),
          Ingredient(userRef: 1, name: 'Cucumber')
        ];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(meal: meal, ingredients: ingredients, onCamera: () {}),
        ));

        // Act
        await tester.enterText(find.byType(TextField), 'invalid search');
        await tester.pump(); // Rebuild the widget

        // Assert
        expect(find.text('Tomato'), findsNothing); // Incorrect search should not find "Tomato"
        expect(find.text('Lettuce'), findsNothing); // Incorrect search should not find "Lettuce"
        expect(find.text('Cucumber'), findsNothing); // Incorrect search should not find "Cucumber"
      });
    });

    group('AddIngredientPage Dialog Tests', () {
      testWidgets('should show dialog if ingredient has no image', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [
          Ingredient(userRef: 1, name: 'Tomato', imageUrl: null),
        ];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(meal: meal, ingredients: ingredients, onCamera: () {}),
        ));

        // Act
        await tester.tap(find.text('Tomato'));
        await tester.pump(); // Open dialog

        // Assert
        expect(find.text('Der er ikke et billede til denne ingrediens, tilføj dette nu.'), findsOneWidget);
      });

      // This one fails. It might be bacause of the placeholder image.
      testWidgets('should not show dialog if ingredient has image', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [
          Ingredient(userRef: 1, name: 'Tomato', imageUrl: 'https://via.placeholder.com/150'),
        ];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(meal: meal, ingredients: ingredients, onCamera: () {}),
        ));

        // Act
        await tester.tap(find.text('Tomato'));
        await tester.pump(); // No dialog should open

        // Assert
        expect(find.text('Der er ikke et billede til denne ingrediens, tilføj dette nu.'), findsNothing); // No dialog expected
      });
    });

    group('AddIngredientPage Callback Tests', () {
      testWidgets('should call onCamera callback', (WidgetTester tester) async {
        bool cameraCalled = false;

        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [
          Ingredient(userRef: 1, name: 'Tomato', imageUrl: null),
        ];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(
            meal: meal,
            ingredients: ingredients,
            onCamera: () {
              cameraCalled = true;
            },
          ),
        ));

        // Act
        await tester.tap(find.text('Tomato'));
        await tester.pump(); // Open dialog
        await tester.tap(find.text('OK'));
        await tester.pump(); // Trigger callback

        // Assert
        expect(cameraCalled, isTrue);
      });

      // This one fails. It might be bacause of the placeholder image.
      testWidgets('should not call onCamera callback for ingredient with image', (WidgetTester tester) async {
        bool cameraCalled = false;

        // Arrange
        Meal meal = Meal();
        List<Ingredient> ingredients = [
          Ingredient(userRef: 1, name: 'Tomato', imageUrl: 'https://via.placeholder.com/150'),
        ];

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(
            meal: meal,
            ingredients: ingredients,
            onCamera: () {
              cameraCalled = true;
            },
          ),
        ));

        // Act
        await tester.tap(find.text('Tomato'));
        await tester.pump(); // No callback should be called

        // Assert
        expect(cameraCalled, isFalse); // Callback should not be called
      });
    });
  });
}