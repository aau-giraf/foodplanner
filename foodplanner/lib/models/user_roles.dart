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

  int toFlagValue() {
    int value = 0;

    if (hasRole(Role.admin))   value |= 1 << 0;
    if (hasRole(Role.child))   value |= 1 << 1;
    if (hasRole(Role.teacher)) value |= 1 << 2;
    if (hasRole(Role.parent))  value |= 1 << 3;

    return value;
  }

  factory UserRole.fromString(String value) => UserRole.fromFlagValue(int.parse(value));

  factory UserRole.fromFlagValue(int value) {
    final roles = <Role>{};
    if (value & (1 << 0) != 0) roles.add(Role.admin);
    if (value & (1 << 1) != 0) roles.add(Role.child);
    if (value & (1 << 2) != 0) roles.add(Role.teacher);
    if (value & (1 << 3) != 0) roles.add(Role.parent);

    return UserRole._(roles);
  }

  @override
  String toString() => toFlagValue().toString();
}