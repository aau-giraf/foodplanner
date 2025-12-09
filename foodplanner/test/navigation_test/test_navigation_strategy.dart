
import 'package:flutter/src/material/navigation_bar.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';

//subclass fordi NavigationStrategy klassen er abstract.
class TestNavigationStrategy extends NavigationStrategy{
  
  //konkret liste af pages
  TestNavigationStrategy() {
    pages = ['/home', '/settings', '/profile'];
  }
  
  @override
  List<NavigationDestination> getDestinations(UserRoles role) {
    return [];
  }

}