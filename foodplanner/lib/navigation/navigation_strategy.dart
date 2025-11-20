import 'package:flutter/material.dart';
import 'package:foodplanner/routes/user_roles.dart';

abstract class NavigationStrategy {
  void navigate(int index, BuildContext context, ROLES? role);

  List<NavigationDestination> getDestinations();
}