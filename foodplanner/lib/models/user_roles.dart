enum Role { admin, teacher, guardian, pupil }

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

  factory UserRoles.fromString(String value) =>
      UserRoles.of(value.split(",").map((str) =>
    switch (str.trim().toLowerCase()){
      "admin" => Role.admin,
      "teacher" => Role.teacher,
      "parent" => Role.guardian,
      "child" => Role.pupil,
      String() => throw InvalidRoleStringException(str),
    }));

  @override
  String toString() => roles.map((r) => switch(r) {
    Role.guardian => "parent",
    Role.pupil => "child",
    _ => r.name
  } ).join(",");
}

class InvalidRoleStringException implements Exception {
  final String message;

  InvalidRoleStringException(this.message);

  @override
  String toString() => 'InvalidRoleStringException: $message';
}
