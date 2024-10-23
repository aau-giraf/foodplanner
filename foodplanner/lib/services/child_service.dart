import 'dart:convert';
import 'package:foodplanner/models/child.dart';
import 'package:http/http.dart' as http;

class ChildService {
  final String apiUrl;

  ChildService({required this.apiUrl});

  Future<Child> fetchChild() async {
    final response = await http.get(Uri.parse('$apiUrl/api/Childrens/Get/1'));

    if (response.statusCode == 200) {
      return Child.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Kunne ikke hente Barn');
    }
  }

  Future<http.Response> createChild(
      String firstName, String lastName, int parentId, int classId) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/Childrens/Create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'parentId': parentId.toString(),
        'classId': classId.toString(),
      }),
    );

    return response;
  }
}
