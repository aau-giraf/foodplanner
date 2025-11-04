import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/components/button.dart';

@GenerateMocks([http.Client])
void main() {

  MealFormPage createWidgetUnderTest() {
    return MealFormPage(
    );
  }
  
  group('MealFormPage ', () {
    group('contains widget: ', () {
      testWidgets('TextField prompt', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.text('Navn på madpakke'), findsOneWidget);
      });
      testWidgets('Navn fx. "Rugbrød med ost og grønt"', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.byType(TextField), findsOneWidget);
      });
      testWidgets('Button prompt', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.text('Tilføj ingredienser'), findsOneWidget);
      });
      testWidgets('create meal button', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(home: createWidgetUnderTest()),
        );
        expect(find.text('Opret madpakke'), findsAtLeastNWidgets(1));
      });
    });
  });
  group('navigates to:', () {
    testWidgets('CameraPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest()),
      );

      await tester.tap(find.widgetWithText(CustomButton, 'Opret madpakke'));
      await tester.pumpAndSettle();

      // await tester.tap(find.text('Ja'));
      // await tester.pumpAndSettle();

      expect(find.text('Vil du tilføje et billede af madpakken?'), findsOneWidget);
    });

    testWidgets('AddIngredientPage', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: createWidgetUnderTest()),
      );

      await tester.tap(find.text('Tilføj ingredienser'));
      await tester.pumpAndSettle();

      expect(find.text('Her kan du tilføje ingredienser til din madpakke.\nDu kan tilføje ingredienser fra din egen liste eller tilføje nye ingredienser.'), findsOneWidget);

      await tester.tap(find.text('Tilføj'));
      await tester.pumpAndSettle();

      expect(find.text('Tilføj madvare'), findsOneWidget);

    });
  });
}