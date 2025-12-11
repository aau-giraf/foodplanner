// Den faktiske Role enum fra foodplanner/models/user_roles.dart
enum Role { admin, teacher, pupil, guardian }

// Mock af UserRoles til at kontrollere admin-status
class MockUserRoles {
  final Set<Role> _roles;

  MockUserRoles(Iterable<Role> roles) : _roles = roles.toSet();

  bool hasRole(Role role) {
    return _roles.contains(role);
  }
  
  // Nødvendig for at simulere den faktiske implementering (hvis den findes)
  static MockUserRoles empty() => MockUserRoles({});
  static MockUserRoles of(Iterable<Role> roles) => MockUserRoles(roles);
}


// I din User-model mock (MockUserService) skal du sørge for at bruge denne mock:
/*
// I mock_user_service.dart
import 'package:foodplanner/models/user_roles.dart' as original;
import '../mocks/mock_user_roles.dart' as mock;

// ...
  return User(
    // ...
    role: isAdmin ? mock.MockUserRoles.of([mock.Role.admin]) : mock.MockUserRoles.of([mock.Role.user]),
    // ...
  );
*/