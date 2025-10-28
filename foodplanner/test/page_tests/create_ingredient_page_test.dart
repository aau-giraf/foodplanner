import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/pages/create_ingredient_page.dart';

void main() {
  group('CreateIngredientPage tests', () {
    testWidgets('CreateIngredientPage has the expected texts, as well as a button and textfield', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CreateIngredientPage())
      );
      await tester.pumpAndSettle();
      
      expect(find.text('Tilbage'), findsOneWidget);
      
      expect(find.text('Tilføj madvare'), findsOneWidget);
  
      expect(find.byType(TextField), findsOneWidget);

      expect(find.byType(CustomButton), findsOneWidget);
    });

    testWidgets('Checks if text field accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CreateIngredientPage())
      );

      await tester.enterText(find.byType(TextField), 'Banan');
      expect(find.text('Banan'), findsOneWidget);
    });

    testWidgets('Creates new ingredient with entered input', (WidgetTester tester) async {
      Ingredient createdIngredient = Ingredient(
        id: 1,
        name: "Banan",
      );
      
      await tester.pumpWidget(
        MaterialApp(home: CreateIngredientPage(),
      ));

      await tester.enterText(find.byType(TextField), 'Banan');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CustomButton));
      await tester.pumpAndSettle();

      expect(createdIngredient.name, 'Banan');
    });
  });
}