import 'dart:convert';

import 'package:http/http.dart' as http;

class User {
  final int id;
  final String first_name;
  final String last_name;
  final String email;
  final String password;

  const User({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'first_name': String first_name,
        'last_name': String last_name,
        'email': String email,
        'password': String password,
      } =>
        User(
          id: id,
          first_name: first_name,
          last_name: last_name,
          email: email,
          password: password,
        ),
      _ => throw const FormatException('Bruger kunne ikke findes.'),
    };
  }
}

Future<User> fetchUser() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:80/api/Users/Get/1'));

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Kunne ikke hente bruger');
  }
}

Future<http.Response> createUser(
    String firstName, String lastName, String email, String password) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:80/api/Users/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
    }),
  );

  return response;
}
