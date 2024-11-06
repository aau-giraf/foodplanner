import 'dart:convert';
import 'package:foodplanner/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/auth/auth_provider.dart';

class UserService {
  final String apiUrl;

  UserService({required this.apiUrl});

  Future<User> fetchUser() async {
    final response = await http.get(Uri.parse('$apiUrl/api/Users/Get/1'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Kunne ikke hente bruger');
    }
  }

  Future<List<User>> fetchApproveUsers() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
      Uri.parse('$apiUrl/api/Admin/GetNotApproved'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map<User>((json) => User.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<User>> updateApproveUsers(int id) async {
    final response = await http.put(
      Uri.parse('$apiUrl/api/Users/ApproveRole/$id'),
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
      Uri.parse('$apiUrl/api/Users/Delete/$id'),
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
      Uri.parse('$apiUrl/api/Users/Create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role
      }),
    );

    return response;
  }

  Future<http.Response> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/Users/Login'),
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
}
