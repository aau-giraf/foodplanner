import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/navigation/navigation_destination_helper.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AdminRolesNavStrategy extends NavigationStrategy {

  List<String> _pages = [ADMIN_ROLES_ROOT, SETTINGS_PAGE, LOGIN_PAGE];

  @override
  set pages(List<String> pages) {
    _pages = pages;
  }

  @override
  List<String> get pages => _pages;

  @override
  void navigate(int index, BuildContext context, UserRoles? role) async{
    switch(index) {
      case 0 || 1:
        navigate(index, context, role);
      case 2:
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.logout();
        GoRouter.of(context).go(LOGIN_PAGE);
    }
    
    NavigationService.setCurrentPage(index);

  }
  
  @override
  List<NavigationDestination> getDestinations(UserRoles role) {
    return [
      NavigationDestinationHelper.buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: SFIcons.sf_gearshape, selectedIcon: SFIcons.sf_gearshape_fill, label: '', isSfIcon: true),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.logout_outlined, selectedIcon: Icons.logout, label: ''),
    ];
    
  }
  
}