enum Role { admin, teacher, parent, student, child }

class UserRole {
  final Set<Role> roles;

  const UserRole._(this.roles);

  factory UserRole.of(Iterable<Role> roles) => UserRole._({...roles});
  factory UserRole.empty() => const UserRole._({});

  bool hasRole(Role role) => roles.contains(role);

  bool hasAllRoles(Iterable<Role> roleList) {
    var value = true;
    for (Role role in roleList) {
      value = value && roles.contains(role);
    }

    return value;
  }

  bool hasOneOfRoles(Iterable<Role> roleList) {
    for (Role role in roleList) {
      if (roles.contains(role)){
        return true;
      }
    }

    return false;
  }

  UserRole add(Role role) => UserRole._({...roles, role});

  factory UserRole.fromString(String value) {
    List<String> roleValues = value.split(",");
    var userRole = UserRole.empty();

    for (var role in Role.values){
      if(roleValues.contains(role.name)){
        userRole = userRole.add(role);
      }
    }

    return userRole;
  }

  @override
  String toString() => roles.map((r) => r.name).join(",");
}