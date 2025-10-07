import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/pages/edit_meal_form_page.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'add_meal_page_test.mocks.dart';

@GenerateMocks([http.Client, AuthProvider])
void main() {
  final List<Ingredient> ingredients = [
    Ingredient(id: 0, name: 'æble', foodImageId: null),
    Ingredient(id: 1, name: 'knækbrød', foodImageId: 1),
    Ingredient(id: 2, name: 'franskbrød', foodImageId: 2),
  ];

  late MockClient mockClient;
  late AuthProvider mockAuthProvider;

  setUp(() {
    mockClient = MockClient();
    mockAuthProvider = MockAuthProvider();
  });

  Future<Meal> mockFetchMeal(http.Client client, AuthProvider auth, int mealId) async {
    return Meal(
      id: mealId,
      name: 'meal1',
      foodImageId: 0,
      date: DateTime.now(),
      ingredients: [
        PackedIngredient(id: 0, mealId: mealId, ingredient: Ingredient(id: 1, name: 'knækbrød', foodImageId: 1)),
        PackedIngredient(id: 0, mealId: mealId, ingredient: Ingredient(id: 2, name: 'franskbrød', foodImageId: 2))
      ]
    );
  }

  Future<List<Ingredient>> mockFetchIngredients(http.Client client, AuthProvider auth) async {
    return ingredients;
  }

  EditMealFormPage createWidgetUnderTest(GlobalKey key) {
  final meal = Meal(
    id: 0,
    name: 'meal1',
    foodImageId: 0,
    date: DateTime.now(),
    ingredients: [
      PackedIngredient(id: 0, mealId: 0, ingredient: Ingredient(id: 1, name: 'knækbrød', foodImageId: 1)),
      PackedIngredient(id: 0, mealId: 0, ingredient: Ingredient(id: 2, name: 'franskbrød', foodImageId: 2)),
    ],
  );

  return EditMealFormPage(
    key: key,
    meal: meal,
    packedIngredients: meal.ingredients,
    ingredients: [
      Ingredient(id: 0, name: 'æble', foodImageId: null),
      Ingredient(id: 1, name: 'knækbrød', foodImageId: 1),
      Ingredient(id: 2, name: 'franskbrød', foodImageId: 2),
    ],
    onAddIngredients: () {},
    onCamera: () {},
    client: mockClient,
    image: null,
  );
}

  group('EditMealPage Navigation Tests', () {
    testWidgets('initializes at EditMealFormPage', (WidgetTester tester) async {
      final GlobalKey<EditMealPageState> addMealPageKey = GlobalKey<EditMealPageState>();

      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest(addMealPageKey)),
      );
      await tester.pump();

      expect(find.byType(EditMealFormPage), findsOneWidget);
    });

    testWidgets('navigates to AddIngredientPage', (WidgetTester tester) async {
      final GlobalKey<EditMealPageState> addMealPageKey = GlobalKey<EditMealPageState>();

      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest(addMealPageKey)),
      );
      addMealPageKey.currentState!.pushPage(1);
      await tester.pump();

      expect(find.byType(AddIngredientPage), findsOneWidget);
    });

    testWidgets('navigates to CameraPage', (WidgetTester tester) async {
      final GlobalKey<EditMealPageState> addMealPageKey = GlobalKey<EditMealPageState>();

      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest(addMealPageKey)),
      );
      addMealPageKey.currentState!.pushPage(2);
      await tester.pump();

      expect(find.byType(CameraPage), findsOneWidget);
    });
  });
}