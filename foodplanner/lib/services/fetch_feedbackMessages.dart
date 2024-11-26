import 'dart:convert';
import 'package:foodplanner/pages/feedbackChatPage.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_provider.dart';

class FeedbackService{
  final String apiUrl;

  FeedbackService({required this.apiUrl});

  Future<List<Map<String, dynamic>>> fetchGetFeedbackMessages(int chatThreadId, AuthProvider authProvider) async {
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



Future<void> fetchSendFeedbackMessage({
  required int userId,
  required int chatThreadId,
  required String content,
  required AuthProvider authProvider,
}) async {
  final token = await authProvider.retrieveToken();

  // Create the request payload
  final Map<String, dynamic> requestBody = {
    "userId": userId,
    "chatThreadId": chatThreadId,
    "content": content,
  };

  try {
    final response = await http.post(
      Uri.parse('$apiUrl/api/FeedbackChat/AddMessage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody), // Serialize the request body as JSON
    );

    if (response.statusCode == 200) {
      print('Message sent successfully: ${response.body}');
      // Optionally, parse the response if needed
    } else {
      print('Failed to send message. Status code: ${response.statusCode}');
      throw Exception('Failed to send feedback message.');
    }
  } catch (e) {
    print('Problem with sending feedback message: $e');
    rethrow;
  }
}













}