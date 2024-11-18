import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth/auth_provider.dart';

class MealService {
  final String apiUrl;

  MealService({required this.apiUrl});

  Future<Map<String, String>> fetchMealData(String date) async {
    try {
      final jwtToken = await AuthProvider().retrieveToken();
      final response = await http.get(
        Uri.parse('$apiUrl/api/Meals/GetAllByUser?date=$date'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String title = data['title'];
        final String image_ref = data['image_ref'];

        return {'title': title, 'image_ref': image_ref};
      } else {
        throw Exception('Failed to load meal data');
      }
    } catch (e) {
      print('Error fetching meal data: $e');
      return {};
    }
  }
}
