import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodplanner/pages/landing_page_teacher.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_provider.dart';
import '../models/user_roles.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class AuthService {
  final String apiUrl;

  AuthService({required this.apiUrl});


 
Future<UserRoles> fetchAuthData(String email, String password) async {
  try {
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String jwt = data['jwt'];
      final bool roleApproved = data['roleApproved'];
      String roleValueString = data['role'];

      UserRoles authRole = UserRoles.fromString(roleValueString);

      await AuthProvider().login(authRole, jwt, roleApproved);
      return authRole;
    } else {
      var error = jsonDecode(response.body);
      throw AuthException(error['Message'] ?? 'Failed to load auth data');
    }
  } catch (e) {
    print('Error fetching auth data: $e');
    throw NetworkException('Forkert email eller adgangskode');
  }
}
}
