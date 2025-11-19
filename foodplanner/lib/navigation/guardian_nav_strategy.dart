
import 'package:flutter/material.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';

class GuardianNavStrategy implements NavigationStrategy {
 
  @override
  void navigate(int index, BuildContext context, ROLES? role) {
    switch(index) {
        case 0:
          GoRouter.of(context).go(PARENT_ROOT);
          break;
        case 1:
          GoRouter.of(context).go(CHOOSE_CHILD);
          break;                
        case 2:
          GoRouter.of(context).go(SETTINGS_PAGE);
          break;
        case 3: 
          //() async {
          //  final authProvider = Provider.of<AuthProvider>(context, listen: false);
          //  await authProvider.logout();
          //  context.go(LOGIN_PAGE);
          GoRouter.of(context).go(LOGIN_PAGE);
          break;
      }
  }
}