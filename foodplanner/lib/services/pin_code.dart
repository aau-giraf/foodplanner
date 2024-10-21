import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';
import '../auth/auth_provider.dart';
import '../routes/user_roles.dart';

class PinService {
  final String apiUrl;

  PinService({required this.apiUrl});

  Future<dynamic> postPin(int userId, List<int> pincode) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/Users/CheckPinCode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': userId,
          'pinCode': pincode.join(),
        }),
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        var error = jsonDecode(response.body);
        return error;
        //throw Exception('Failed to load pincode');
      }
    } catch (e) {
      print('Error checking pincode: $e');
    }
  }

  Future<dynamic> fetchAuthData(String Email, String Password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/Users/Login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': Email,
          'password': Password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String jwt = data['jwt'];
        final bool roleApproved = data['roleApproved'];
        final String role = data['role'];

        ROLES authRole = roleFromString(role.toLowerCase());
        await AuthProvider().login(authRole, jwt, roleApproved);
      } else {
        var error = jsonDecode(response.body);
        return error;
        //throw Exception('Failed to load auth data');
      }
      // sabrina carpenter <3
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
