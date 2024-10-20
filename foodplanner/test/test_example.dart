import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/main.dart';

// As flutter utilises dart it has its own test test libraries, but can also use darts
// To run in the terminal, locate the project folder and write: flutter test
// To mock data read at https://docs.flutter.dev/cookbook/testing/unit/mocking

void main() {
  // Use group() to split tests into sections
  // To run a test group in the terminal, locate the project folder and write: flutter test --plain-name "group description"
  group('group description', () {

    // Use test() to run a single test on dart code
    test('test description', () {
      bool expected  = false;

      bool actual = 'This is where you should mock data and run the test'.isEmpty;

      // Use expect() as an assertion to test an expected value against actual value, in the form of the Matcher class
      // The matcher can be a value you have created or a predined matcher.
      // Predefined matchers can be found at https://api.flutter.dev/flutter/package-matcher_matcher/package-matcher_matcher-library.html
      // Just a heads up, there are a lot of predined matchers.
      expect(actual, expected);
    });
  });

  // Use testWidgets() to perform an interaction with a widget in your test
  // Be sure to input the WidgetTester class
  // You can read further about the WidgetTester here: https://api.flutter.dev/flutter/flutter_test/WidgetTester-class.html
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
