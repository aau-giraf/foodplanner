import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/auth/auth_provider.dart';

class UserService {
  final String apiUrl;

  UserService({required this.apiUrl});

  Future<User> fetchUser(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(Uri.parse('$apiUrl/api/Admin/Get/${id}'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final filteredJson = {
        'id': json['id'],
        'first_name': json['firstName'],
        'last_name': json['lastName'],
        'email': json['email'],
        'role': json['role'],
        'archived': json['archived'],
      };
      return User.fromJson(filteredJson);
    } else {
      throw Exception('Kunne ikke hente bruger');
    }
  }

  Future<User> fetchLoggedInUser() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(Uri.parse('$apiUrl/api/Users/GetLoggedIn'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final filteredJson = {
        'id': json['id'],
        'first_name': json['first_name'],
        'last_name': json['last_name'],
        'email': json['email'],
        'role': json['role'],
        'archived': json['archived'],
      };
      return User.fromJson(filteredJson);
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

  Future<bool> updateApproveUsers(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.put(
      Uri.parse('$apiUrl/api/Admin/UpdateRoleApproved/$id'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': id,
        'role_approved': true,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update and approve users');
    }
  }

  Future<bool> unapproveUsers(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.delete(
      Uri.parse('$apiUrl/api/Admin/Delete/$id'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      print(
          'Failed to unapprove users: ${response.statusCode} ${response.body}');
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

  Future<List<User>> fetchAllParents() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http
        .get(Uri.parse('$apiUrl/api/Admin/GetAll'), headers: <String, String>{
      'Authorization': 'Bearer $jwtToken',
    });
    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);

      return usersJson
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Kunne ikke hente forældre');
    }
  }

  Future<List<User>> fetchAllUsers() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
      Uri.parse('$apiUrl/api/Admin/GetAll'),
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

  Future<dynamic> updateArchived(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.put(
      Uri.parse('$apiUrl/api/Admin/UpdateArchived/$id'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      return {'Message': 'Kunne ikke opdatere brugeren'};
    }
  }
}
