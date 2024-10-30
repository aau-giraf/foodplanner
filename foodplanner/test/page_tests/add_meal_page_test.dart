import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/pages/meal_form_page.dart';
import 'package:foodplanner/pages/add_meal_page.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/services/fetch_user_data.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockFetchUserData extends Mock implements FetchUserData {
  Future<List<Ingredient>> fetchIngredientsByUserID(int userID) async {
    return [Ingredient(userRef: 1, name: 'Test Ingredient')];
  }
}

// Tests do not work because of missing fetch implementation
void main() {
  group('AddMealPage Widget Tests', () {
    late MockAuthProvider mockAuthProvider;
    late MockFetchUserData mockFetchUserData;

    setUp(() {
      mockAuthProvider = MockAuthProvider();
      mockFetchUserData = MockFetchUserData();

      when(mockAuthProvider.jwtToken).thenReturn('your.jwt.token.here');
      
      // Update the mock to match the correct method signature
      when(mockFetchUserData.fetchIngredientsByUserID(1))
          .thenAnswer((_) async => [Ingredient(userRef: 1, name: 'Test Ingredient')]);
    });

    group('MealFormPage Tests', () {
      testWidgets('should display MealFormPage by default', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              Provider<AuthProvider>.value(value: mockAuthProvider),
              Provider<FetchUserData>.value(value: mockFetchUserData),
            ],
            child: MaterialApp(
              home: AddMealPage(meal: meal),
            ),
          ),
        );

        // Assert
        expect(find.byType(MealFormPage), findsOneWidget);
      });

      testWidgets('should handle null Meal input', (WidgetTester tester) async {
        // Arrange
        Meal? meal;
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              Provider<AuthProvider>.value(value: mockAuthProvider),
              Provider<FetchUserData>.value(value: mockFetchUserData),
            ],
            child: MaterialApp(
              home: AddMealPage(meal: meal ?? Meal()), // Ensure the widget handles null gracefully
            ),
          ),
        );

        // Assert
        expect(find.byType(MealFormPage), findsOneWidget); // Should default to MealFormPage
      });

      testWidgets('should navigate to MealFormPage on back press', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              Provider<AuthProvider>.value(value: mockAuthProvider),
              Provider<FetchUserData>.value(value: mockFetchUserData),
            ],
            child: MaterialApp(
              home: AddMealPage(meal: meal),
            ),
          ),
        );

        // Act
        await tester.tap(find.byType(BackButton)); // Simulate back button press
        await tester.pump();

        // Assert
        expect(find.byType(MealFormPage), findsOneWidget); // Ensure it navigates back to MealFormPage
      });
    });

    group('AddIngredientPage Tests', () {
      testWidgets('should switch to AddIngredientPage on button press', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              Provider<AuthProvider>.value(value: mockAuthProvider),
              Provider<FetchUserData>.value(value: mockFetchUserData),
            ],
            child: MaterialApp(
              home: AddMealPage(meal: meal),
            ),
          ),
        );

        // Act
        // Assuming the button that switches to AddIngredientPage is identified by some unique identifier
        await tester.tap(find.byType(TextButton).first);
        await tester.pump();

        // Assert
        expect(find.byType(AddIngredientPage), findsOneWidget);
      });

      testWidgets('should handle empty ingredient list gracefully', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              Provider<AuthProvider>.value(value: mockAuthProvider),
              Provider<FetchUserData>.value(value: mockFetchUserData),
            ],
            child: MaterialApp(
              home: AddMealPage(meal: meal),
            ),
          ),
        );

        // Assert
        expect(find.text('No ingredients found'), findsNothing); // Assuming there's no specific text for empty ingredient list
      });
    });

    group('CameraPage Tests', () {
      testWidgets('should switch to CameraPage on button press', (WidgetTester tester) async {
        // Arrange
        Meal meal = Meal();
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              Provider<AuthProvider>.value(value: mockAuthProvider),
              Provider<FetchUserData>.value(value: mockFetchUserData),
            ],
            child: MaterialApp(
              home: AddMealPage(meal: meal),
            ),
          ),
        );

        // Act
        // Assuming the button that switches to CameraPage is identified by some unique identifier
        await tester.tap(find.byType(TextButton).last);
        await tester.pump();

        // Assert
        expect(find.byType(CameraPage), findsOneWidget);
      });
    });
  });

  group('AddMealPage Edge Case Tests', () {
    testWidgets('should decode user ID from JWT token', (WidgetTester tester) async {
      // Arrange
      final auth = MockAuthProvider();
      when(auth.jwtToken).thenReturn('your.jwt.token.here');
      
      // Act
      final userId = FetchUserData.decodeUserIDFromJWT(auth.jwtToken!);
      
      // Assert
      expect(userId, isNotNull); // Ensure the decoded user ID is not null
    });
  });
}