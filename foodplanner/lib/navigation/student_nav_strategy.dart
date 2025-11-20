
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/navigation/navigation_destination_helper.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';

class StudentUnlockedNavStrategy extends NavigationStrategy {

  List<String> _pages = [FEEDBACK_Page, STUDENT_UNLOCKED, SETTINGS_PAGE, STUDENT_ROOT];

  @override
  set pages(List<String> pages) {
    _pages = pages;
  }

  @override
  List<String> get pages => _pages;

  @override
  void navigate(int index, BuildContext context, ROLES? role) {
    String goToPage = pages[index];
    GoRouter.of(context).go(goToPage);

    /*
    switch(index) {
        case 0: 
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
    */
    
    NavigationService.setCurrentPage(index);
  }

  @override
  List<NavigationDestination> getDestinations(){
    return [
      NavigationDestinationHelper.buildIconDestination(icon: SFIcons.sf_message, selectedIcon: SFIcons.sf_message_fill, label: '', isSfIcon: true),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.lunch_dining_outlined, selectedIcon: Icons.lunch_dining, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: SFIcons.sf_gearshape, label: '', selectedIcon: SFIcons.sf_gearshape_fill, isSfIcon: true),
      NavigationDestinationHelper.buildIconDestination(icon: SFIcons.sf_lock, label: '', selectedIcon: SFIcons.sf_lock_fill, isSfIcon: true),
    ];
  }
  
  
}