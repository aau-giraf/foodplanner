enum Role { admin, teacher, parent, student, child }

class UserRoles {
  final Set<Role> roles;

  const UserRoles._(this.roles);

  factory UserRoles.of(Iterable<Role> roles) => UserRoles._({...roles});
  factory UserRoles.empty() => const UserRoles._({});

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

  UserRoles add(Role role) => UserRoles._({...roles, role});

  factory UserRoles.fromString(String value) {
    List<String> roleValues = value.split(",").map((s) => s.trim().toLowerCase()).toList();
    var userRole = UserRoles.empty();
    for (var role in Role.values){
      if(roleValues.contains(role.name)){  // role.name is already lowercase
        userRole = userRole.add(role);
      }
    }
    return userRole;
  }

  @override
  String toString() => roles.map((r) => r.name).join(",");
}