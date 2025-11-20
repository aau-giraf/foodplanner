
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/navigation/navigation_destination_helper.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';

class GuardianNavStrategy extends NavigationStrategy {
 
  List<String> _pages = [PARENT_ROOT, CHOOSE_CHILD, SETTINGS_PAGE, LOGIN_PAGE];

  @override
  set pages(List<String> pages) {
    _pages = pages;
  }

  @override
  List<String> get pages => _pages;

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
    
    NavigationService.setCurrentPage(index);

  }
  
  @override
  List<NavigationDestination> getDestinations() {
    return [
      NavigationDestinationHelper.buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.escalator_warning_outlined, selectedIcon: Icons.escalator_warning, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: SFIcons.sf_gearshape, label: '', selectedIcon: SFIcons.sf_gearshape_fill, isSfIcon: true),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.logout_outlined, selectedIcon: Icons.logout, label: ''),
    ];
  }

  
}