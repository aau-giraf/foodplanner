import 'package:flutter/material.dart';

import 'user_roles.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final UserRoles role;
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
        'role': String role,
        'archived': bool archived,
      } => 
        User(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          role: UserRoles.fromString(role),
          archived: archived,
        ),
      _ => throw const FormatException('Bruger kunne ikke findes.'),
    };
  }
}

class UserLogin {
  final String jwt;
  final bool roleApproved;
  final UserRoles role;

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
        'role': String role,
      } =>
        UserLogin(
          jwt: jwt,
          roleApproved: roleApproved,
          role: UserRoles.fromString(role),
        ),
      _ => throw const FormatException('Bruger kunne ikke findes.'),
    };
  }
}

class GuardianUser {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final UserRoles role;
  final bool roleApproved;
  final int? pinCode;
  final bool archived;

  const GuardianUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.role,
    required this.roleApproved,
    this.pinCode,
    required this.archived,
  });
  
  factory GuardianUser.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'firstName': String firstName,
        'lastName': String lastName,
        'email': String email,
        'password': String password,
        'role': int role,
        'roleApproved': bool roleApproved,
        'pinCode': int? pinCode,
        'archived': bool archived,
      } => 
        GuardianUser(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          role: UserRoles.fromInt(role),
          roleApproved: roleApproved,
          pinCode: pinCode,
          archived: archived,
        ),
      _ => throw const FormatException('Bruger kunne ikke findes.'),
    };
  }
}
