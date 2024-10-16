import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_provider.dart';
import '../routes/user_roles.dart';

class AuthService {
  final String apiUrl;

  AuthService({required this.apiUrl});

  Future<void> fetchAuthData(AuthProvider authProvider) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/auth/status'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool isLoggedIn = data['isLoggedIn'];
        final String role = data['role'];

        if (isLoggedIn) {
          authProvider.login(roleFromString(role));
        } else {
          authProvider.logout();
        }
      } else {
        throw Exception('Failed to load auth data');
      }
    } catch (e) {
      print('Error fetching auth data: $e');
    }
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