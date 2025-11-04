import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/pages/meal_list_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('MealListPage ', () {
    late GoRouter goRouter;
    late bool mealPageNavigated;

    setUp(() {
      mealPageNavigated = false;
      goRouter = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const MealListPage(),
          ),
          GoRoute(
            path: '/create',
            builder: (context, state) {mealPageNavigated = true; return Container();},
          ),
        ],
      );
    });

    group('contains widget: ', () {
      testWidgets('No ingredient message', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: goRouter,
          ),
        );
        expect(find.text('Ingen madpakke at vise'), findsOneWidget);
      });

      testWidgets('Add ingredient button', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: goRouter,
          ),
        );
        expect(find.byIcon(Icons.add), findsOneWidget);
      });
    });

    group('navigates to:', () {
      testWidgets('AddMealPage', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: goRouter,
          ),
        );

        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        expect(mealPageNavigated, true);
      });
    });
  });
}