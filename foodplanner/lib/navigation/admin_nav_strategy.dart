import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/navigation/navigation_destination_helper.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';

class AdminNavStrategy extends NavigationStrategy {

  List<String> _pages = [ADMIN_ROOT, SETTINGS_PAGE, LOGIN_PAGE];

  @override
  set pages(List<String> pages) {
    _pages = pages;
  }

  @override
  List<String> get pages => _pages;

  @override
  void navigate(int index, BuildContext context, UserRoles? role){
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
    
    NavigationService.setCurrentPage(index);

  }
  
  @override
  List<NavigationDestination> getDestinations() {
    return [
      NavigationDestinationHelper.buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.manage_accounts_outlined, selectedIcon: Icons.manage_accounts, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.school_outlined, selectedIcon: Icons.school, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: SFIcons.sf_gearshape, selectedIcon: SFIcons.sf_gearshape_fill, label: '', isSfIcon: true),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.room_preferences_outlined, selectedIcon: Icons.room_preferences, label: ''),
    ];
  }  
}