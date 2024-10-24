import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';
import '../auth/auth_provider.dart';
import '../routes/user_roles.dart';

class PinService {
  final String apiUrl;

  PinService({required this.apiUrl});

  Future<dynamic> checkPin(int userId, List<int> pincode) async {
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

  Future<dynamic> createPin(int userId, List<int> pincode) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/api/Users/CreatePinCode'),
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
}
