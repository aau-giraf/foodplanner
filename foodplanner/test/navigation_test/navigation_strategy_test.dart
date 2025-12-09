import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/models/user_roles.dart';

class TestNavigationStrategy extends NavigationStrategy {
  TestNavigationStrategy({required List<String> testPages}) {
    pages = testPages;
  }

  @override
  List<NavigationDestination> getDestinations(UserRoles role) {
    return [];
  }
}

/// Test widget der giver os et BuildContext med en GoRouter
class TestApp extends StatelessWidget {
  final GoRouter router;
  final Widget child;

  const TestApp({required this.router, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

void main() {
  late TestNavigationStrategy strategy;

  setUp(() {
    NavigationService.setCurrentPage(0);
    strategy = TestNavigationStrategy(
      testPages: ['/', '/profil', '/indstillinger'],
    );
  });

  group("NavigationStrategy with real GoRouter", () {
    testWidgets('navigate updates NavigationService', (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/profil', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/indstillinger', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(TestApp(router: router, child: const SizedBox()));
      await tester.pump();

      final context = tester.element(find.byType(SizedBox).first);

      strategy.navigate(2, context);
      await tester.pumpAndSettle();

      expect(NavigationService.getCurrentPage(), 2);
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/indstillinger');
    });

    testWidgets('goToPage sets correct index', (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/profil', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/indstillinger', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(TestApp(router: router, child: const SizedBox()));
      await tester.pump();

      final context = tester.element(find.byType(SizedBox).first);

      strategy.goToPage('/profil', context);
      await tester.pumpAndSettle();

      expect(NavigationService.getCurrentPage(), 1);
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/profil');
    });

    testWidgets('navigateToHomePage goes to index 0', (tester) async {
      final router = GoRouter(
        initialLocation: '/indstillinger',
        routes: [
          GoRoute(path: '/', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/profil', builder: (_, __) => const SizedBox()),
          GoRoute(path: '/indstillinger', builder: (_, __) => const SizedBox()),
        ],
      );

      await tester.pumpWidget(TestApp(router: router, child: const SizedBox()));
      await tester.pump();

      final context = tester.element(find.byType(SizedBox).first);

      NavigationService.setCurrentPage(99);

      strategy.navigateToHomePage(context, UserRoles.empty());
      await tester.pumpAndSettle();

      expect(NavigationService.getCurrentPage(), 0);
      expect(router.routerDelegate.currentConfiguration.uri.toString(), '/');
    });
  });
}
