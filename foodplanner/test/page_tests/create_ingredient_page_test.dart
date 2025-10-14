import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/components/icon_button.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/pages/create_ingredient_page.dart';

void main() {
  group('CreateIngredientPage tests', () {
    testWidgets('Creates CreateIngredientPage correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CreateIngredientPage(onCreatedIngredient: (ingredient) {}))
      );

      expect(find.text('Ingrediens'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(CustomElevatedButton), findsOneWidget);
    });

    testWidgets('Checks if text field accepts input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CreateIngredientPage(onCreatedIngredient: (ingredient) {}))
      );

      await tester.enterText(find.byType(TextField), 'Banan');
      expect(find.text('Banan'), findsOneWidget);
    });

    testWidgets('Shows CupertinoDialog on button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CreateIngredientPage(onCreatedIngredient: (ingredient) {}))
      );

      await tester.enterText(find.byType(TextField), 'Banan');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CustomElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      expect(find.text('Er du sikker på du vil tilføje denne madvare?'), findsOneWidget);
    });

    testWidgets('Creates new ingredient on confirmation', (WidgetTester tester) async {
      Ingredient createdIngredient = Ingredient(
        id: 1,
        name: "Banan",
        imageRef: 1,
      );
      
      await tester.pumpWidget(
        MaterialApp(home: CreateIngredientPage(
          onCreatedIngredient: (ingredient) {
            createdIngredient = ingredient;
          }
        ),
      ));

      await tester.enterText(find.byType(TextField), 'Banan');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CustomElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ja'));
      await tester.pumpAndSettle();

      expect(createdIngredient.name, 'Banan');
    });

    testWidgets('Closes the dialog on cancellation', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: CreateIngredientPage(onCreatedIngredient: (ingredient) {}))
      );

      await tester.enterText(find.byType(TextField), 'Banan');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CustomElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text("Nej"));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsNothing); 
    });
  });
}