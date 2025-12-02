import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/navigation/navbar_strategy_mapper.dart';
import 'package:foodplanner/navigation/navigation_service.dart';

class ActiveRoleService {
  static Role? _activeRole = null;
  
  static Role? get activeRole => _activeRole;

  static void setActiveRole(Role? role) {
    _activeRole = role;
  }
}