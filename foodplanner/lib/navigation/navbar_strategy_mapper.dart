import 'package:foodplanner/navigation/user_nav_strategies/admin_nav_strategy.dart';
import 'package:foodplanner/navigation/user_nav_strategies/admin_roles_nav_strategy.dart';
import 'package:foodplanner/navigation/user_nav_strategies/admin_teacher_nav_strategy.dart';
import 'package:foodplanner/navigation/user_nav_strategies/parent_nav_strategy.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/navigation/user_nav_strategies/student_nav_strategy.dart';
import 'package:foodplanner/navigation/user_nav_strategies/teacher_nav_strategy.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/services/active_role_service.dart';

class NavBarStrategyMapper {
  static NavigationStrategy getNavBarStrategy(UserRoles role) {  
    var activeRole = ActiveRoleService.activeRole;
    
    if(activeRole == Role.teacher && role.hasAllRoles([Role.admin, Role.teacher])) {
      return new AdminTeacherNavStrategy();

    } else if (role.hasOnlyRole(Role.teacher)) {
      return new TeacherNavStrategy();
    
    } else if (role.hasOnlyRole(Role.guardian)) {
      return new ParentNavStrategy();
    
    } else if (role.hasOnlyRole(Role.pupil) || role.hasOnlyRole(Role.pupil)) {
      return new StudentUnlockedNavStrategy();
    
    } else if (activeRole == Role.admin && role.hasAllRoles([Role.admin, Role.teacher])) {
      return new AdminNavStrategy();
    
    } else if (role.hasAllRoles([Role.admin, Role.teacher])) {
      return new AdminRolesNavStrategy();
      
    } else if (role.hasOnlyRole(Role.admin)) {
      return new AdminNavStrategy();

    } else {
      throw Exception("No navigation strategy was found for this role $role");
    }
  }
}

