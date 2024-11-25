import 'dart:convert';
import 'package:foodplanner/pages/feedbackChatPage.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_provider.dart';

class FeedbackService{
  final String apiUrl;

  FeedbackService({required this.apiUrl});

  Future<List<Map<String, dynamic>>> fetchFeedbackMessages(int chatThreadId, AuthProvider authProvider) async {
  final token = await authProvider.retrieveToken();

  try {
    final response = await http.get(
      Uri.parse('$apiUrl/api/FeedbackChat/GetMessages/$chatThreadId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Decode JSON into a List of Maps
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load feedback message data');
    }
  } catch (e) {
    print('problem with feedback messages: $e');
    return [];
  }
}

}