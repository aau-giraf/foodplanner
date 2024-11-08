import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/pages/meal_form_page.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';

// Mock VoidCallback
class MockCallback extends Mock {
  void call();
}

void main() {
  group('MealFormPage Widget Tests', () {
    late Meal meal;
    late List<Ingredient> ingredients;
    late MockCallback mockOnAddIngredients;
    late MockCallback mockOnCamera;
    late Client mockClient;

    // Initial setup before tests
    setUp(() {
      meal = Meal();
      ingredients = [Ingredient(name: "Knækbrød"), Ingredient(name: "Æble")];
      mockOnAddIngredients = MockCallback();
      mockOnCamera = MockCallback();
      mockClient = Client();
    });

    group('Initialization Tests', () {
      testWidgets('should initialize with default values', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: MealFormPage(
            packedIngredients: meal.getPackedIngredients,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ));

        // Assert
        // Check that there are two instances of "Opret madpakke"
        expect(find.text('Opret madpakke'), findsNWidgets(2));

        // Act
        // Check that one of them is the AppBar title
        final appBarFinder = find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Opret madpakke'),
        );
        expect(appBarFinder, findsOneWidget);

        // Assert
        // Check for the TextField
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('should handle null ingredients gracefully', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: MealFormPage(
            packedIngredients: meal.getPackedIngredients,
            ingredients: null,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ));

        // Assert
        expect(find.text('Tilføj ingredienser'), findsOneWidget);
      });
    });

    group('Title TextField Tests', () {
      testWidgets('should enter text in the title field', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: MealFormPage(
            packedIngredients: meal.getPackedIngredients,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ));

        // Act
        await tester.enterText(find.byType(TextField), 'My Meal Title');

        // Assert
        expect(find.text('My Meal Title'), findsOneWidget);
      });

      testWidgets('should handle null or empty text', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: MealFormPage(
            packedIngredients: meal.getPackedIngredients,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ));

        // Act
        await tester.enterText(find.byType(TextField), '');

        // Assert
        expect(find.text('Skriv her...'), findsOneWidget);
      });
    });

    group('Add Ingredient Button Tests', () {
      testWidgets('should call onAddIngredients when button is tapped', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: MealFormPage(
            packedIngredients: meal.getPackedIngredients,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ));

        // Act
        await tester.tap(find.byIcon(Icons.add));

        // Assert
        verify(mockOnAddIngredients()).called(1);
      });

      testWidgets('should handle unexpected interaction', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: MealFormPage(
            packedIngredients: meal.getPackedIngredients,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ));

        // Act
        await tester.tap(find.byIcon(Icons.add));

        // Assert
        verify(mockOnAddIngredients()).called(1);
      });
    });

    group('Create Meal Button Tests', () {
      testWidgets('should show dialog when create meal button is tapped', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: MealFormPage(
            packedIngredients: meal.getPackedIngredients,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ));

        // Act
        final createMealButton = find.widgetWithText(CustomElevatedButton, 'Opret madpakke');
        await tester.tap(createMealButton);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      });

      testWidgets('should handle null input for meal title', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: MealFormPage(
            packedIngredients: meal.getPackedIngredients,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ));

        // Act
        final createMealButton = find.widgetWithText(CustomElevatedButton, 'Opret madpakke');
        await tester.tap(createMealButton);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      });

      testWidgets('should handle unexpected input for meal title', (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(MaterialApp(
          home: MealFormPage(
            packedIngredients: meal.getPackedIngredients,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ));

        // Act
        await tester.enterText(find.byType(TextField), 'Unexpected Title 123');
        final createMealButton = find.widgetWithText(CustomElevatedButton, 'Opret madpakke');
        await tester.tap(createMealButton);
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      });
    });
  });
}