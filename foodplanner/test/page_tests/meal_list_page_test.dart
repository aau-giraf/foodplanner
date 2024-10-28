import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/pages/add_meal_page.dart';
import 'package:foodplanner/pages/meal_form_page.dart';
import 'package:foodplanner/pages/meal_list_page.dart';
import 'package:foodplanner/components/empty_meal_list_element.dart';
import 'package:foodplanner/components/meal.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('MealListPage Widget Tests', () {
    late List<Meal> meals;

    setUp(() {
      meals = <Meal>[];
    });

    group('Initialization Tests', () {
      testWidgets('should display empty meal list when no meals are present', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: MealListPage()));
        await tester.pumpAndSettle();
        
        // Check the AppBar title
        final appBarFinder = find.descendant(
          of: find.byType(AppBar),
          matching: find.text('Velkommen, .'),
        );
        expect(appBarFinder, findsOneWidget);
        
        // Check for the EmptyMealListElement
        expect(find.byType(EmptyMealListElement), findsOneWidget);
      });

    // Can't be tested yet, as MealListElement is not implemented.
    
    //   testWidgets('should display meal list when meals are present', (WidgetTester tester) async {
    //     meals = [Meal(title: 'Knækbrød med ost + frugt', date: DateTime.now())];
    //     await tester.pumpWidget(MaterialApp(
    //       home: Scaffold(
    //         body: SingleChildScrollView(
    //           child: Column(
    //             children: [
    //               Expanded(
    //                 child: ListView.separated(
    //                   itemCount: meals.length,
    //                   itemBuilder: (context, index) {
    //                     return MealListElement(meal: meals[index]);
    //                   },
    //                   separatorBuilder: (context, index) => const SizedBox(height: 10),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ));
    //     await tester.pumpAndSettle();

    //     // Check for the MealListElement
    //     expect(find.byType(MealListElement), findsOneWidget);
    //   });
    });

    group('EmptyMealListElement Tests', () {
      testWidgets('should display EmptyMealListElement when no meals are present', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: MealListPage()));
        await tester.pumpAndSettle();

        expect(find.byType(EmptyMealListElement), findsOneWidget);
      });

      testWidgets('should display date and empty meal message correctly', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: EmptyMealListElement()));
        await tester.pumpAndSettle();

        expect(find.text('Ingen madpakke at vise'), findsOneWidget);
        expect(find.textContaining('Madpakke i dag d. '), findsOneWidget);
      });

      // Cant make this work. I think the problem comes from the button being in EmptyMealListElement.dart
      testWidgets('should navigate to add meal page when button is tapped', (WidgetTester tester) async {
        final GoRouter goRouter = GoRouter(
          initialLocation: MealListPage.routeName,
          routes: [
            GoRoute(
              path: MealListPage.routeName,
              builder: (BuildContext context, GoRouterState state) => const MealListPage(),
            ),
            GoRoute(
              path: AddMealPage.routeName,
              builder: (BuildContext context, GoRouterState state) => const AddMealPage(),
            ),
          ],
        );

        await tester.pumpWidget(MaterialApp.router(
          routerDelegate: goRouter.routerDelegate,
          routeInformationParser: goRouter.routeInformationParser,
          routeInformationProvider: goRouter.routeInformationProvider,
        ));

        await tester.pumpAndSettle();

        // Ensure that the default page is MealListPage
        expect(find.byType(MealListPage), findsOneWidget);

        // Tap the add button at the bottom
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        // Verify navigation to AddMealPage
        expect(find.byType(AddMealPage), findsOneWidget);

        // Verify that MealFormPage is shown within AddMealPage
        expect(find.byType(MealFormPage), findsOneWidget);
      });
    });
  });
}