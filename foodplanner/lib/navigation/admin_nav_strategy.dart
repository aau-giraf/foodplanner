import 'package:flutter/material.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';

class AdminNavStrategy implements NavigationStrategy {

  @override
  void navigate(int index, BuildContext context, ROLES? role){
    switch(index) {
      case 0:
        GoRouter.of(context).go(ADMIN_ROOT);
        break;
      case 1:
        GoRouter.of(context).go(SETTINGS_PAGE);
        break;
      case 2:
        GoRouter.of(context).go(LOGIN_PAGE);
    }
  }
}