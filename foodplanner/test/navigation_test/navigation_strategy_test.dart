
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';

import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/models/user_roles.dart';

import 'navigation_service_test.mocks.dart';

class TestNavigationStrategy extends NavigationStrategy {
  TestNavigationStrategy({required List<String> testPages}) {
    pages = testPages;
  }

  @override
  List<NavigationDestination> getDestinations(UserRoles role) {
    return [];
  }
}

@GenerateMocks([BuildContext, GoRouter])
void main() {



  late TestNavigationStrategy strategy;
  late List<String> testPages;
  late MockBuildContext mockContext;

  setUp(() {
    //arrange 1
    NavigationService.setCurrentPage(0);

    //arrange 2
    testPages = ['/', '/profil', '/indstillinger'];
    strategy = TestNavigationStrategy(testPages: testPages);
    mockContext = MockBuildContext();

  });

  group('NavigationStrategy Core Logic', () {
    test('navigate should update NavigationService with the correct index', () {
      const targetIndex = 2;
      
      //act 1
      strategy.navigate(targetIndex, mockContext);

      //assert 1
      expect(NavigationService.getCurrentPage(), targetIndex, reason: 'NavigationService should update to index 2');
      
      //eventuelt tjek med et andet index
    });

    test('goToPage should find the correct index based on path and update NavigationService', () {
      const targetPage = '/profil';

      //act 2
      strategy.goToPage(targetPage, mockContext);

      //assert 2
      expect(NavigationService.getCurrentPage(), 1, reason: 'NavigationService should update to index 1 which is the page /profil');
    });

    test('navigateToHomePage should navigate to the first page (index 0) and update NavigationService', () {
      //arrange
      NavigationService.setCurrentPage(99);
      final UserRoles dummyRole = UserRoles.empty();

      //act
      strategy.navigateToHomePage(mockContext, dummyRole);

      //assert
      expect(NavigationService.getCurrentPage(), 0, reason: 'The page should always be index 0 in this implementation');
    });
  });
}