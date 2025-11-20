import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/navigation/admin_nav_strategy.dart';
import 'package:foodplanner/navigation/admin_teacher_nav_strategy.dart';
import 'package:foodplanner/navigation/parent_nav_strategy.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/navigation/student_nav_strategy.dart';
import 'package:foodplanner/navigation/teacher_nav_strategy.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/navigation/navigation_destination_helper.dart';

class NavBarStrategyMapper {
  
  static NavigationStrategy getNavBarStrategy(UserRoles role) {  
    if (role.hasOnlyRole(Role.teacher)) {
      return new TeacherNavStrategy();
    
    } else if (role.hasOnlyRole(Role.parent)) {
        return new ParentNavStrategy();
    
    } else if (role.hasOnlyRole(Role.student)) {
        return new StudentUnlockedNavStrategy();
    
    } else if (role.hasAllRoles([Role.admin, Role.teacher])) {
        return new AdminTeacherNavStrategy();
    
    } else if (role.hasOnlyRole(Role.admin)) {
      return new AdminNavStrategy();

    } else {
        throw Exception("No navigation strategy was found for this role $role");
    }
  }
}

