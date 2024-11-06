import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_provider.dart';
import '../routes/user_roles.dart';

class ChildrenService {
  final String apiUrl;

  ChildrenService({required this.apiUrl});

  Future<List<Map<String, String>>> fetchChildrenData() async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/Childrens/GetAllChildren'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{}), // Add an empty body if no data is needed
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Assuming the response contains a list of children
        // Process the data as needed
        print('Children data: $data');
        return data;
      } else {
        throw Exception('Failed to load children data');
      }
    } catch (e) {
      print('Error fetching children data: $e');
    }
      return [];
  }

  ROLES roleFromString(String role) {
    switch (role) {
      case 'teacher':
        return ROLES.teacher;
      case 'student':
        return ROLES.student;
      case 'admin':
        return ROLES.admin;
      case 'parent':
        return ROLES.parent;
      default:
        throw Exception('Unknown role: $role');
    }
  }
}