import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/navigation/admin_nav_strategy.dart';
import 'package:foodplanner/navigation/guardian_nav_strategy.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/navigation/student_nav_strategy.dart';
import 'package:foodplanner/navigation/teacher_nav_strategy.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/navigation/navigation_destination_helper.dart';

class NavBarStrategyMapper {
  
  static NavigationStrategy getNavBarStrategy(ROLES role) {  
    switch(role) {
      case ROLES.teacher:
        return new TeacherNavStrategy();
      
      case ROLES.guardian:
        return new GuardianNavStrategy();
      
      case ROLES.student:
        return new StudentUnlockedNavStrategy();

      case ROLES.admin:
        return new AdminNavStrategy();
      
      default:
        throw Exception("No navigation strategy was found for this role $role");
    }
  }
}

