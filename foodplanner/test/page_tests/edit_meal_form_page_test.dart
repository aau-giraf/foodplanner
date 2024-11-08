import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/components/edit_meal_ingredient_list_element.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/edit_meal_form_page.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';

// Mock callback class
class MockCallback extends Mock {
  void call();
}

void main() {
  group('EditMealFormPage Widget Tests', () {
    late Meal meal;
    late List<Ingredient> ingredients;
    late MockValueSetter mockOnAddIngredients;
    late MockCallback mockOnCamera;
    late Client mockClient;
    late ValueChanged<List<Ingredient>> mockOnIngredientsUpdated;

    // Initial setup before tests
    setUp(() {
      meal = Meal();
      ingredients = [Ingredient(name: "Knækbrød"), Ingredient(name: "Æble")];
      mockOnAddIngredients = MockValueSetter();
      mockOnCamera = MockCallback();
      mockClient = Client();
      mockOnIngredientsUpdated = (List<Ingredient> updatedIngredients) {};
    });

    testWidgets('should display AppBar with title', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients.valuesetter(1),
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ),
      );
      
      // Assert
      expect(find.text('Rediger madpakke'), findsOneWidget);
    });

    testWidgets('should display list of ingredients', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ),
      );

      // Assert
      expect(find.text('Knækbrød'), findsOneWidget);
      expect(find.text('Æble'), findsOneWidget);
    });

    testWidgets('should call onAddIngredients when add button is tapped', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Assert
      verify(mockOnAddIngredients()).called(1);
    });

    testWidgets('should save changes and pop when save button is tapped', (WidgetTester tester) async {
      final meal = Meal();
      final ingredients = [Ingredient(name: "Knækbrød"), Ingredient(name: "Æble")];
      final mockOnAddIngredients = MockCallback();
      final mockOnCamera = MockCallback();
      final mockOnIngredientAdded = MockCallback();

      // Router for testing the page shifting.
      final router = GoRouter(
        initialLocation: '/add',
        routes: [
          GoRoute(
            path: '/add',
            builder: (context, state) => AddIngredientPage(
              ingredients: ingredients,
              onIngredientsUpdated: mockOnIngredientsUpdated,
              onCamera: mockOnCamera,
              onIngredientAdded: mockOnIngredientAdded,
              client: mockClient,
            ),
          ),
          GoRoute(
            path: '/edit',
            builder: (context, state) => EditMealFormPage(
              meal: meal,
              ingredients: ingredients,
              onAddIngredients: mockOnAddIngredients,
              onCamera: mockOnCamera,
              client: mockClient,
            ),
          ),
        ],
      );

      // Arrange
      await tester.pumpWidget(
        MaterialApp.router(
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
        ),
      );

      // Ensure the `AddIngredientPage` is displayed first
      expect(find.text('Find madvare'), findsOneWidget);

      // Act: Navigate to the `EditMealFormPage`
      router.push('/edit');
      await tester.pumpAndSettle();

      // Assert: Ensure the `EditMealFormPage` is displayed
      expect(find.text('Rediger madpakke'), findsOneWidget);

      // Act: Tap the save button and ensure navigation happens
      await tester.tap(find.text('Gem ændringer'));
      await tester.pumpAndSettle();

      // Assert: Verify that the `EditMealFormPage` is popped from the stack
      expect(find.text('Rediger madpakke'), findsNothing);
      expect(find.text('Find madvare'), findsOneWidget); // Ensure it returns to the `AddIngredientPage`
    });

    testWidgets('should handle empty ingredient list gracefully', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: [],
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ),
      );

      // Assert
      expect(find.byType(EditMealIngredientListElement), findsNothing);
    });

    testWidgets('should handle null ingredients gracefully', (WidgetTester tester) async {
      // Arrrange
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: null,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ),
      );

      // Assert
      expect(find.byType(EditMealIngredientListElement), findsNothing);
    });

    testWidgets('should handle extremely long ingredient names gracefully', (WidgetTester tester) async {
      // Arrange
      ingredients = [
        Ingredient(name: "A" * 500), // Very long ingredient name
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ),
      );

      // Assert
      expect(find.text("A" * 500), findsOneWidget);
    });

    testWidgets('should handle special characters in ingredient names', (WidgetTester tester) async {
      // Arrange
      ingredients = [
        Ingredient(name: "!@#\$%^&*()_+-=[]{}|;:'\",.<>?/"),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
            client: mockClient,
          ),
        ),
      );

      // Assert
      expect(find.text("!@#\$%^&*()_+-=[]{}|;:'\",.<>?/"), findsOneWidget);
    });
  });
}