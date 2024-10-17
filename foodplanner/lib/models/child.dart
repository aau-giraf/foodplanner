import 'dart:convert';

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

Future<Child> fetchChild() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:80/api/Childrens/Get/1'));

  if (response.statusCode == 200) {
    return Child.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Kunne ikke hente Barn');
  }
}

Future<http.Response> createChild(
    String firstName, String lastName, int parentId, int classId) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:80/api/Childrens/Create'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'first_name': firstName,
      'last_name': lastName,
      'parent_id': parentId.toString(),
      'classId': classId.toString(),
    }),
  );

  return response;
}
