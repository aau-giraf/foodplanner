import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'add_ingredient_page_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final List<Ingredient> ingredients = [
    Ingredient(id: 0, name: 'æble', imageRef: null),
    Ingredient(id: 1, name: 'knækbrød', imageRef: 1),
    Ingredient(id: 2, name: 'franskbrød', imageRef: 2),
  ];

  late bool cameraNavigated;
  late bool ingredientCreated;
  late bool ingredientAdded;

  setUp(() {
    cameraNavigated = false;
    ingredientCreated = false;
    ingredientAdded = false;
  });

  AddIngredientPage createWidgetUnderTest() {
    return AddIngredientPage(
      ingredients: ingredients,
      image: null,
      onIngredientsUpdated: (_) {},
      onCreateIngredient: () => ingredientCreated = true,
      onCamera: () => cameraNavigated = true,
      onIngredientAdded: (_) => ingredientAdded = true,
      client: MockClient(),
    );
  }

  group('AddIngredientPage ', () {
    group('contains widget: ', () {
      testWidgets('TextField to search through ingredients', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('TextButton to represent each ingredient', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.byType(TextButton), findsNWidgets(ingredients.length));
      });
    });

    group('searchbar functionality', () {
      testWidgets('filters ingredients based on search input', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );

        expect(find.byType(TextButton), findsNWidgets(ingredients.length));

        await tester.enterText(find.byType(TextField), 'æble');
        await tester.pumpAndSettle();

        final filteredCount = ingredients.where((ingredient) => ingredient.name.contains('æble')).length;
        expect(find.byType(TextButton), findsNWidgets(filteredCount));
      });
    });

    group('ingredient button functionality', () {
      testWidgets('shows CupertinoAlertDialog if ingredient lacks an image', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );

        await tester.tap(find.text('æble'));
        await tester.pumpAndSettle();

        expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      });

      testWidgets('calls onIngredientAdded callback', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );

        await tester.tap(find.text('knækbrød'));
        await tester.pumpAndSettle();

        expect(ingredientAdded, isTrue);
      });
    });

    group('create ingredient button functionality', () {
      testWidgets('calls onIngredientCreated callback', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(ingredientCreated, isTrue);
      });
    });

    group('navigates to:', () {
      testWidgets('CameraPage when pressing OK in the alert dialog', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );

        await tester.tap(find.text('æble'));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(CupertinoDialogAction));
        await tester.pumpAndSettle();

        expect(cameraNavigated, isTrue);
      });
    });
  });
}