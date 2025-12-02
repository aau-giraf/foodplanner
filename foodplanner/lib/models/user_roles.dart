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

  bool hasOnlyRole(Role role) {
    return roles.contains(role) && roles.length == 1;
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

  factory UserRoles.fromInt(int value){
    var userRole = UserRoles.empty();
    for (var role in Role.values){
      int roleBit = 1 << role.index;
      if((value & roleBit) != 0){
        userRole = userRole.add(role);
      }
    }
    print("role from int: $userRole"); // for debugging purposes
    return userRole;
  }

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
