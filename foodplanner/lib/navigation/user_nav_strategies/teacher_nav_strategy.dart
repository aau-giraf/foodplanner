import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/navigation/navigation_destination_helper.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:provider/provider.dart';

class TeacherNavStrategy extends NavigationStrategy {

  List<String> _pages = [TEACHER_ROOT, CHOOSE_PUPIL_TEACHER, SETTINGS_PAGE, LOGIN_PAGE];

  @override
  set pages(List<String> pages) {
    _pages = pages;
  }

  @override
  List<String> get pages => _pages;

  @override
  void navigate(int index, BuildContext context) async {
    switch(index) {
      case 0 || 1 || 2:
        super.navigate(index, context);
        break;
      case 3: 
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.logout();
        if(!context.mounted) {
          return;
        }
        super.navigate(index, context);
        
        break;
    }
    
    NavigationService.setCurrentPage(index);
  }

  @override
  List<NavigationDestination> getDestinations(UserRoles role){
    return [
      NavigationDestinationHelper.buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.escalator_warning_outlined, selectedIcon: Icons.escalator_warning, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: SFIcons.sf_gearshape, label: '', selectedIcon: SFIcons.sf_gearshape_fill, isSfIcon: true),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.logout_outlined, selectedIcon: Icons.logout_outlined, label: ''),
    ];
  }
}

