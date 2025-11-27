import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/child.dart';
import 'package:http/http.dart' as http;

class ChildService {
  final String apiUrl;

  ChildService({required this.apiUrl});

  Future<List<Child>> fetchChild() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
        Uri.parse('$apiUrl/api/Admin/GetAllChildren'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        });

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body) as List<dynamic>;
      var responseList = jsonResponse
          .map((child) => Child.fromJson(child as Map<String, dynamic>))
          .toList();
      return responseList;
    } else if (response.statusCode == 403) {
      throw Exception('Du er ikke autherized til denne funktion');
    } else {
      throw Exception('Børn kunne ikke hentes');
    }
  }

  Future<Child> fetchChildById() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
      Uri.parse('$apiUrl/api/Childrens/GetChildrenByParentId'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Child.fromJson(data);
    } else {
      throw Exception('Failed to load child data');
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

  Future<http.Response> updateChild(int id, String firstName, String lastName,
      int parentId, int classId) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.put(
      Uri.parse('$apiUrl/api/Admin/UpdateChild'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(<String, dynamic>{
        'ChildId': id,
        'firstName': firstName,
        'lastName': lastName,
        'parentId': parentId,
        'classId': classId,
      }),
    );

    return response;
  }

  Future<http.Response> deleteChild(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.delete(
      Uri.parse('$apiUrl/api/Childrens/Delete/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );

    return response;
  }

  Future<Child> getByChildId(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
        Uri.parse('$apiUrl/api/Childrens/GetChildFromChildId/$id'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        });
    if (response.statusCode == 200) {
      //debugPrint('response.body: ${response.body}', wrapWidth: 2048);
      final data = json.decode(response.body);
      //debugPrint('child data: ${data}');
      final child = Child.fromJson(data);
      //debugPrint('child from data: ${child}');
      return child;
    } else {
      throw Exception('Failed to load child data');
    }
  }
}
