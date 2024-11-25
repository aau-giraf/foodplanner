import 'dart:convert';
import 'package:foodplanner/pages/feedbackChatPage.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_provider.dart';

class FeedbackService{
  final String apiUrl;

  FeedbackService({required this.apiUrl});

  Future<Map<String, String>> fetchFeedbackMessages(int chatThreadId, AuthProvider authProvider) async {
    final token = await authProvider.retrieveToken();


    try {
      final response = await http.get(Uri.parse('$apiUrl/api/FeedbackChat/GetMessages/${chatThreadId}'), 
      headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return data;
        }
       else {
        throw Exception('Failed to load feedback message data');
      }
    } catch (e) {
      print('proble with feedback messages: $e');
      return {};
    }
  }
}