import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/pages/add_ingredient_page.dart';
import 'package:foodplanner/pages/create_ingredient_page.dart';
import 'package:foodplanner/services/ingredient_services.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_ingredient_page_test.mocks.dart';

// class MockIngredientServices extends Mock implements IngredientServices {}
// class MockAuthProvider extends Mock implements AuthProvider {}

@GenerateMocks([http.Client, IngredientServices, AuthProvider])
void main() {
  late MockIngredientServices mockIngredientServices;
  late MockAuthProvider mockAuthProvider;

  final List<Ingredient> ingredients = [
    Ingredient(id: 0, name: 'æble', foodImageId: null),
    Ingredient(id: 1, name: 'knækbrød', foodImageId: 1),
    Ingredient(id: 2, name: 'franskbrød', foodImageId: 2),
  ];

  setUp(() {
    mockIngredientServices = MockIngredientServices();
    mockAuthProvider = MockAuthProvider();
  });

  AddIngredientPage createWidgetUnderTest() => AddIngredientPage(authProvider: MockAuthProvider(), ingredientServices: MockIngredientServices());

  group('AddIngredientPage ', () {
    group('contains widget: ', () {
      testWidgets('TextField to search through ingredients', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.byType(TextField), findsOneWidget);
      });
    });

    group('searchbar functionality', () {
      // Test might break as https://github.com/aau-giraf/foodplanner/pull/114 gets pushed.
      testWidgets('correct amount of ingredients on initializitation', (WidgetTester tester) async {
        when(mockIngredientServices.fetchIngredientsByUserID(mockAuthProvider)).thenAnswer((_) async => ingredients);
       
        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(
            ingredientServices: mockIngredientServices,
            authProvider: mockAuthProvider,
          ),
        ));
        
        await tester.pumpAndSettle();

        expect(find.byType(SettingsWidget), findsNWidgets(ingredients.length + 1));
      });

      // this functionality hasn't been added yet
      // testWidgets('filters ingredients based on search input', (WidgetTester tester) async {
      //   when(mockIngredientServices.fetchIngredientsByUserID(mockAuthProvider)).thenAnswer((_) async => ingredients);
       
      //   await tester.pumpWidget(MaterialApp(
      //     home: AddIngredientPage(
      //       ingredientServices: mockIngredientServices,
      //       authProvider: mockAuthProvider,
      //     ),
      //   ));
        
      //   await tester.pumpAndSettle();

      //   await tester.enterText(find.byType(TextField), 'æble');
      //   await tester.pumpAndSettle();

      //   final filteredCount = ingredients.where((ingredient) => ingredient.name.contains('æble')).length;
      //   expect(find.byType(TextButton), findsNWidgets(filteredCount));
      // });

      testWidgets('renders all ingredients after fetch', (WidgetTester tester) async {
        // Arrange
        when(mockIngredientServices.fetchIngredientsByUserID(mockAuthProvider)).thenAnswer((_) async => ingredients);

        // Act
        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(
            ingredientServices: mockIngredientServices,
            authProvider: mockAuthProvider,
          ),
        ));

        await tester.pumpAndSettle();

        // Assert
        final settingsWidgets = find.byType(SettingsWidget);
        debugPrint('Found ${settingsWidgets.evaluate().length} SettingsWidget(s)');
        expect(settingsWidgets, findsNWidgets(ingredients.length + 1)); // +1 header
      });
    });

    group('create ingredient button functionality', () {
      testWidgets('adds ingredient and updates list length', (WidgetTester tester) async {
        when(mockIngredientServices.fetchIngredientsByUserID(mockAuthProvider)).thenAnswer((_) async => ingredients);

        await tester.pumpWidget(MaterialApp(
          home: AddIngredientPage(
            ingredientServices: mockIngredientServices,
            authProvider: mockAuthProvider,
          ),
        ));

        await tester.pumpAndSettle();

        final initialCount = tester.widgetList(find.byType(SettingsWidget)).length;

        await tester.tap(find.text('Tilføj'));
        await tester.pumpAndSettle();

        expect(find.byType(CreateIngredientPage), findsOneWidget);

        final created = Ingredient(id: 3, name: 'gullerød');
        Navigator.of(tester.element(find.byType(CreateIngredientPage))).pop(created);

        await tester.pumpAndSettle();

        final newCount = tester.widgetList(find.byType(SettingsWidget)).length;
        expect(newCount, initialCount + 1);
      });
    });
  });
}