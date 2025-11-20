import 'package:flutter/material.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';

abstract class NavigationStrategy {
  
  List<String> pages = [];
  
  void navigate(int index, BuildContext context, ROLES? role);

  List<NavigationDestination> getDestinations();

  void goToPage(String goToPage, BuildContext context) {
    
    for (int i = 0; i < pages.length ; i++) {
      if(pages[i] == goToPage) {
        GoRouter.of(context).go(goToPage); 
        NavigationService.setCurrentPage(i);
      }
    }
  }
  
  
}