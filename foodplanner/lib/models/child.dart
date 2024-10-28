import 'dart:convert';

import 'package:foodplanner/auth/auth_provider.dart';
import 'package:http/http.dart' as http;

class Child {
  final int id;
  final String firstName;
  final String lastName;
  final int parentId;
  final int classId;

  const Child({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.parentId,
    required this.classId,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'first_name': String firstName,
        'last_name': String lastName,
        'parent_id': int parentId,
        'class_id': int classId,
      } =>
        Child(
          id: id,
          firstName: firstName,
          lastName: lastName,
          parentId: parentId,
          classId: classId,
        ),
      _ => throw const FormatException('Barn kunne ikke findes.'),
    };
  }
}

Future<http.Response> createChild(
    String firstName, String lastName, int classId) async {
  final jwtToken = await AuthProvider().retrieveToken();
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8080/api/Childrens/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwtToken',
    },
    body: jsonEncode(<String, String>{
      'firstName': firstName,
      'lastName': lastName,
      'classId': classId.toString(),
    }),
  );

  return response;
}
