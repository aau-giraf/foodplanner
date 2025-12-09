import 'package:flutter/material.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';

abstract class NavigationStrategy {
  
  List<String> pages = [];
  
  void navigate(int index, BuildContext context) {
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
        //debugPrint('i is $i which is page $goToPage');
      }
    }
  }

  void navigateToHomePage(BuildContext context, UserRoles role) {
    var pageToVisit = pages[0];
    //debugPrint('Navigating to home page ');
    goToPage(pageToVisit, context);
  }  
}