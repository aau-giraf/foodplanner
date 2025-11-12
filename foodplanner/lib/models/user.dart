import 'user_roles.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final UserRole role;
  final bool archived;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.archived,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'first_name': String firstName,
        'last_name': String lastName,
        'email': String email,
        'role': int role,
        'archived': bool archived,
      } =>
        User(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          role: UserRole.fromFlagValue(role),
          archived: archived,
        ),
      _ => throw const FormatException('Bruger kunne ikke findes.'),
    };
  }
}

class UserLogin {
  final String jwt;
  final bool roleApproved;
  final UserRole role;

  const UserLogin({
    required this.jwt,
    required this.roleApproved,
    required this.role,
  });

  factory UserLogin.fromJsonLogin(Map<String, dynamic> json) {
    return switch (json) {
      {
        'jwt': String jwt,
        'roleApproved': bool roleApproved,
        'role': int role,
      } =>
        UserLogin(
          jwt: jwt,
          roleApproved: roleApproved,
          role: UserRole.fromFlagValue(role),
        ),
      _ => throw const FormatException('Bruger kunne ikke findes.'),
    };
  }
}
