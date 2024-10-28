import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/components/edit_meal_ingredient_list_element.dart';
import 'package:foodplanner/components/ingredient.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/edit_meal_form_page.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  group('EditMealFormPage Widget Tests', () {
    late Meal meal;
    late List<Ingredient> ingredients;
    late MockCallback mockOnAddIngredients;
    late MockCallback mockOnCamera;

    setUp(() {
      meal = Meal();
      ingredients = [Ingredient(name: "Knækbrød"), Ingredient(name: "Æble")];
      mockOnAddIngredients = MockCallback();
      mockOnCamera = MockCallback();
    });

    testWidgets('should display AppBar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
          ),
        ),
      );

      expect(find.text('Rediger madpakke'), findsOneWidget);
    });

    testWidgets('should display list of ingredients', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
          ),
        ),
      );

      expect(find.text('Knækbrød'), findsOneWidget);
      expect(find.text('Æble'), findsOneWidget);
    });

    testWidgets('should call onAddIngredients when add button is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: ingredients,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));
      verify(mockOnAddIngredients()).called(1);
    });

    testWidgets('should save changes and pop when save button is tapped', (WidgetTester tester) async {
      final meal = Meal();
      final ingredients = [Ingredient(name: "Knækbrød"), Ingredient(name: "Æble")];
      final mockOnAddIngredients = MockCallback();
      final mockOnCamera = MockCallback();

      final router = GoRouter(
        initialLocation: '/add',
        routes: [
          GoRoute(
            path: '/add',
            builder: (context, state) => AddIngredientPage(
              meal: meal,
              ingredients: ingredients,
              onCamera: mockOnCamera,
            ),
          ),
          GoRoute(
            path: '/edit',
            builder: (context, state) => EditMealFormPage(
              meal: meal,
              ingredients: ingredients,
              onAddIngredients: mockOnAddIngredients,
              onCamera: mockOnCamera,
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerDelegate: router.routerDelegate,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,
        ),
      );

      // Ensure the `AddIngredientPage` is displayed first
      expect(find.text('Find madvare'), findsOneWidget);

      // Navigate to the `EditMealFormPage`
      router.push('/edit');
      await tester.pumpAndSettle();

      // Ensure the `EditMealFormPage` is displayed
      expect(find.text('Rediger madpakke'), findsOneWidget);

      // Tap the save button and ensure navigation happens
      await tester.tap(find.text('Gem ændringer'));
      await tester.pumpAndSettle();
      
      // Verify that the `EditMealFormPage` is popped from the stack
      expect(find.text('Rediger madpakke'), findsNothing);
      expect(find.text('Find madvare'), findsOneWidget); // Ensure it returns to the `AddIngredientPage`
    });

    testWidgets('should handle empty ingredient list gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: [],
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
          ),
        ),
      );

      expect(find.byType(EditMealIngredientListElement), findsNothing);
    });

    testWidgets('should handle null ingredients gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EditMealFormPage(
            meal: meal,
            ingredients: null,
            onAddIngredients: mockOnAddIngredients,
            onCamera: mockOnCamera,
          ),
        ),
      );

      expect(find.byType(EditMealIngredientListElement), findsNothing);
    });

    testWidgets('should handle extremely long ingredient names gracefully', (WidgetTester tester) async {
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
          ),
        ),
      );

      expect(find.text("A" * 500), findsOneWidget);
    });

    testWidgets('should handle special characters in ingredient names', (WidgetTester tester) async {
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
          ),
        ),
      );

      expect(find.text("!@#\$%^&*()_+-=[]{}|;:'\",.<>?/"), findsOneWidget);
    });
  });
}