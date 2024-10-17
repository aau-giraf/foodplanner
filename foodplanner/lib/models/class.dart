import 'dart:convert';

import 'package:http/http.dart' as http;

class Class {
  final int classId;
  final String className;

  const Class({
    required this.classId,
    required this.className,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'classId': int id,
        'className': String className,
      } =>
        Class(
          classId: id,
          className: className,
        ),
      _ => throw const FormatException('Klasse kunne ikke findes.'),
    };
  }

  static List<Class> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => Class.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

Future<List<Class>> fetchAllClasses() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8080/api/Classrooms/GetAll'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    List<Class> classes = Class.fromJsonList(jsonResponse);
    return classes;
  } else {
    throw Exception('Kunne ikke hente Klasser');
  }
}
