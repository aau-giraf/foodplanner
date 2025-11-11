import 'dart:developer' as developer;
import 'dart:convert';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_provider.dart';

class PinService {
  final String apiUrl;

  PinService({required this.apiUrl});

  Future<dynamic> checkPin(List<int> pincode) async {
    try {
      final jwtToken = await AuthProvider().retrieveToken();
      final response = await http.post(
        Uri.parse('$apiUrl/api/Users/CheckPinCode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(<String, dynamic>{
          'pinCode': pincode.join(),
        }),
      );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final String jwt = data['jwt'];
          final bool roleApproved = data['roleApproved'];
          String role = data['role'];
          if (role == "Child"){
          role = "Student";
        }

        ROLES authRole = roleFromString(role.toLowerCase());

        await AuthProvider().login(authRole, jwt, roleApproved);
        return null;
      } else {
        var error = jsonDecode(response.body);
        return error;
        //throw Exception('Failed to load pincode');
      }
    } catch (e) {
     developer.log('Error checking pincode: $e');
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
        return ROLES.guardian;
      default:
        throw Exception('Unknown role: $role');
    }
  }
  Future<dynamic> updatePin(List<int> pincode) async {
    try {
      final jwtToken = await AuthProvider().retrieveToken();
      final response = await http.put(
        Uri.parse('$apiUrl/api/Users/UpdatePinCode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(<String, dynamic>{
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
     developer.log('Error updating pincode: $e');
    }
  }

  Future<dynamic> hasPin() async {
    try {
      final jwtToken = await AuthProvider().retrieveToken();
      final response = await http.get(
        Uri.parse('$apiUrl/api/Users/hasPinCode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return result['hasPinCode'];
      } else {
        var error = jsonDecode(response.body);
        return error;
        //throw Exception('Failed to load pincode');
      }
    } catch (e) {
     developer.log('Error updating pincode: $e');
    }
  }
}
