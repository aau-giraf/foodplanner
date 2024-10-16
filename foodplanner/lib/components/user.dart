import 'dart:convert';

import 'package:http/http.dart' as http;
import '../services/api_config.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;
  final bool roleApproved;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.role,
    required this.roleApproved,
  });

  //I LOVE SABRINA CARPENTER <3

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'first_name': String firstName,
        'last_name': String lastName,
        'email': String email,
        'password': String password,
        'role': String role,
        'role_approved': bool roleApproved,
      } =>
        User(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          role: role,
          roleApproved: roleApproved,
        ),
      _ => throw const FormatException('Bruger kunne ikke findes.'),
    };
  }
}

Future<User> fetchUser() async {
  final response =
      await http.get(Uri.parse('${ApiConfig.baseUrl}/api/Users/Get/1'));

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Kunne ikke hente bruger');
  }
}

Future<http.Response> createUser(String firstName, String lastName,
    String email, String password, String role) async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/api/Users/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'role': role
    }),
  );

  return response;
}

Future<http.Response> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/api/Users/Login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  return response;
}
