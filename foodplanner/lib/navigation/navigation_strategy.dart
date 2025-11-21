import 'package:flutter/material.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';

abstract class NavigationStrategy {
  
  List<String> pages = [];
  
  void navigate(int index, BuildContext context, UserRoles role) {
    String goToPage = pages[index];
    GoRouter.of(context).go(goToPage);

    NavigationService.setCurrentPage(index);
  }

  List<NavigationDestination> getDestinations(UserRoles role);

  void goToPage(String goToPage, BuildContext context) {
    for (int i = 0; i < pages.length ; i++) {
      if(pages[i] == goToPage) {
        GoRouter.of(context).go(goToPage); 
        NavigationService.setCurrentPage(i);
      }
    }
  }

  void navigateToHomePage(BuildContext context, UserRoles role) {
    /*if(role.hasOneOfRoles([Role.child, Role.student])) {
      var pageToVisit = pages[1];
      goToPage(pageToVisit, context); 
    }*/

    var pageToVisit = pages[0];
    goToPage(pageToVisit, context);
  }
  
  
}