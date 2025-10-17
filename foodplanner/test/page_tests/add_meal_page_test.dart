import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/camera_page.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:foodplanner/pages/add_meal_page.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'add_meal_page_test.mocks.dart';

@GenerateMocks([http.Client, AuthProvider])
void main() {
  late MockClient mockClient;
  late AuthProvider mockAuthProvider;

  setUp(() {
    mockClient = MockClient();
    mockAuthProvider = MockAuthProvider();
  });

  Future<List<Ingredient>> mockFetchIngredients(http.Client client, AuthProvider auth) async {
    return [
      Ingredient(id: 0, name: 'æble', imageRef: null),
      Ingredient(id: 1, name: 'knækbrød', imageRef: 1),
      Ingredient(id: 2, name: 'franskbrød', imageRef: 2),
    ];
  }

  AddMealPage createWidgetUnderTest(GlobalKey key) {
    return AddMealPage(
      key: key,
      fetchFunction: mockFetchIngredients,
    );
  }

  group('AddMealPage Navigation Tests', () {
    testWidgets('initializes at MealFormPage', (WidgetTester tester) async {
      final GlobalKey<AddMealPageState> addMealPageKey = GlobalKey<AddMealPageState>();

      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest(addMealPageKey)),
      );
      await tester.pump();

      expect(find.byType(MealFormPage), findsOneWidget);
    });

    testWidgets('navigates to AddIngredientPage', (WidgetTester tester) async {
      final GlobalKey<AddMealPageState> addMealPageKey = GlobalKey<AddMealPageState>();

      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest(addMealPageKey)),
      );
      addMealPageKey.currentState!.pushPage(1);
      await tester.pump();

      expect(find.byType(AddIngredientPage), findsOneWidget);
    });

    testWidgets('navigates to CameraPage', (WidgetTester tester) async {
      final GlobalKey<AddMealPageState> addMealPageKey = GlobalKey<AddMealPageState>();

      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest(addMealPageKey)),
      );
      addMealPageKey.currentState!.pushPage(2);
      await tester.pump();

      expect(find.byType(CameraPage), findsOneWidget);
    });
  });
}