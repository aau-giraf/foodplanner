import 'package:foodplanner/navigation/user_nav_strategies/admin_nav_strategy.dart';
import 'package:foodplanner/navigation/user_nav_strategies/admin_roles_nav_strategy.dart';
import 'package:foodplanner/navigation/user_nav_strategies/admin_teacher_nav_strategy.dart';
import 'package:foodplanner/navigation/user_nav_strategies/guardian_nav_strategy.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/navigation/user_nav_strategies/pupil_nav_strategy.dart';
import 'package:foodplanner/navigation/user_nav_strategies/teacher_nav_strategy.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/services/active_role_service.dart';

class NavBarStrategyMapper {
  static NavigationStrategy getNavBarStrategy(UserRoles role) {  
    var activeRole = ActiveRoleService.activeRole;
    
    //debugPrint('Users active role is ${activeRole.toString()}');
    //debugPrint('All of the users roles: ${role.toString()}');
    
    if(activeRole == Role.teacher && role.hasAllRoles([Role.admin, Role.teacher])) {
      //debugPrint('Returning admin teacher nav strategy');
      return new AdminTeacherNavStrategy();

    } else if (role.hasOnlyRole(Role.teacher)) {
      //debugPrint('Returning teacher nav strategy');
      return new TeacherNavStrategy();
    
    } else if (role.hasOnlyRole(Role.guardian)) {
      //debugPrint('Returning parent nav strategy');
      return new GuardianNavStrategy();
    
    } else if (role.hasOnlyRole(Role.pupil)) {
      //debugPrint('Returning student nav strategy');
      return new PupilUnlockedNavStrategy();
    
    } else if (activeRole == Role.admin && role.hasAllRoles([Role.admin, Role.teacher])) {
      //debugPrint('Returning admin teacher nav strategy where activeRole is admin');
      return new AdminNavStrategy();
    
    } else if (role.hasAllRoles([Role.admin, Role.teacher])) {
      //debugPrint('Returning admin teacher nav strategy');
      return new AdminRolesNavStrategy();
      
    } else if (role.hasOnlyRole(Role.admin)) {
      //debugPrint('Returning admin nav strategy');
      return new AdminNavStrategy();

    } else {
      throw Exception("No navigation strategy was found for this role $role");
    }
  }
}

