import 'package:foodplanner/models/user_roles.dart';

class ActiveRoleService {
  static Role? _activeRole = null;
  
  static Role? get activeRole => _activeRole;

  static void setActiveRole(Role? role) {
    _activeRole = role;
  }
}