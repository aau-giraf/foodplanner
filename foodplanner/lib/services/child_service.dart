import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
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
      String firstName, String lastName, int classId) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.post(
      Uri.parse('$apiUrl/api/Childrens/Create'),
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
}
