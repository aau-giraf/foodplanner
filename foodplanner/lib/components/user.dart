import 'dart:convert';

import 'package:http/http.dart' as http;
import '../services/api_config.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  //I LOVE SABRINA CARPENTER <3

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'first_name': String firstName,
        'last_name': String lastName,
        'email': String email,
        'role': String role,
      } =>
        User(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          role: role,
        ),
      _ => throw const FormatException('Bruger kunne ikke findes.'),
    };
  }
}

class UserLogin {
  final String jwt;
  final bool roleApproved;
  final String role;

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
          role: role,
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

Future<List<User>> fetchApproveUsers() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:80/api/Users/RoleRequests'));

  if (response.statusCode == 200) {
    final List<dynamic> usersJson = jsonDecode(response.body);
    return usersJson
        .map((json) => User.fromJson(json as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Kunne ikke hente approve 0 brugere');
  }
}

Future<List<User>> updateApproveUsers(int id) async {
  final response = await http.put(
    Uri.parse('http://127.0.0.1:80/api/Users/ApproveRole/$id'),
    // Add headers and body if needed
  );

  if (response.statusCode == 200) {
    // Parse the response body and return the list of users
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to update and approve users');
  }
}

Future<List<User>> unapproveUsers(int id) async {
  final response = await http.delete(
    Uri.parse('http://127.0.0.1:80/api/Users/Delete/$id'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to unapprove users');
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
