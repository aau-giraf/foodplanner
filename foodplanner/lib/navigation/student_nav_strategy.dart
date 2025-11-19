
import 'package:flutter/material.dart';
import 'package:foodplanner/navigation/navigation_destination_builder.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';

class StudentNavStrategy implements NavigationStrategy {
  
  @override
  void navigate(int index, BuildContext context, ROLES? role) {
    switch(index) {
        case 0: 
          GoRouter.of(context).go(FEEDBACK_Page);
          break;
        case 1: 
          GoRouter.of(context).go(STUDENT_UNLOCKED);
          break;
        case 2:
          GoRouter.of(context).go(SETTINGS_PAGE);
          break;
        case 3:
          GoRouter.of(context).go(STUDENT_ROOT);
          break;
    }
  }

  
}