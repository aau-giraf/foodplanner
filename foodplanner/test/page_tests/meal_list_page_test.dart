import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/ingredient.dart';
import 'package:foodplanner/pages/meal_list_page.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

void main() {
  group('MealListPage ', () {
    late GoRouter goRouter;
    late bool mealPageNavigated;

    Future<List<Ingredient>> mockFetchIngredients(http.Client client, AuthProvider auth) async {
    return [
      Ingredient(id: 0, name: 'æble', imageRef: null),
      Ingredient(id: 1, name: 'knækbrød', imageRef: 1),
      Ingredient(id: 2, name: 'franskbrød', imageRef: 2),
    ];
  }

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
            path: '/add_meal_page',
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