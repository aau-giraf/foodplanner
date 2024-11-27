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
      body: jsonEncode(requestBody), 
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Message sent successfully: ${response.body}');
    } else {
      print('Failed to send message. Status code: ${response.statusCode}');
      throw Exception('Failed to send feedback message.');
    }
  } catch (e) {
    print('Problem with sending feedback message: $e');
    rethrow;
  }
}
  // For Parent use
  Future<Map<String, dynamic>> fetchGetChatThreadIdAndUserIdFromToken (AuthProvider authProvider) async {
    final token = await authProvider.retrieveToken();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/FeedbackChat/GetChatThreadIdAndUserIdFromToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final int chatThreadId = responseBody['chatThreadId'];
        final int userId = responseBody['userId'];
        return {'chatThreadId': chatThreadId, 'userId': userId};
      } else {
        throw Exception('Failed to load chat thread id and user id');
      }
    } catch (e) {
      print('problem with chat thread id and user id: $e');
      rethrow;
    }
  }

  // For Teacher use
  Future<Map<String, dynamic>> fetchGetChatThreadIdAndUserIdFromChildIdAndToken (int childId, AuthProvider authProvider) async {
    final token = await authProvider.retrieveToken();

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/api/FeedbackChat/GetChatThreadIdAndUserIdFromChildIdAndToken/$childId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final int chatThreadId = responseBody['chatThreadId'];
        final int userId = responseBody['userId'];
        return {'chatThreadId': chatThreadId, 'userId': userId};
      } else {
        throw Exception('Failed to load chat thread id and user id');
      }
    } catch (e) {
      print('problem with chat thread id and user id: $e');
      rethrow;
    }
  }

Future<void> fetchArchieveMessageFromMessageID(int messageId, AuthProvider authProvider) async {
  final token = await authProvider.retrieveToken();

  try {
    final response = await http.delete(
      Uri.parse('$apiUrl/api/FeedbackChat/ArchiveMessage/$messageId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('Message archived successfully');
    } else {
      throw Exception('Failed to archive message');
    }
  } catch (e) {
    print('problem with archiving message: $e');
    rethrow;
  }
}
Future<bool> fetchUpdateMessageFromMessageID(int messageId, String content, AuthProvider authProvider) async {
  final token = await authProvider.retrieveToken();

  final Map<String, dynamic> requestBody = {
    "messageId": messageId,
    "content": content,
  };

  try {
    final response = await http.put(
      Uri.parse('$apiUrl/api/FeedbackChat/UpdateMessage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestBody),
    );
    if (response.statusCode == 200) {
      print('Message updated successfully');
      return true;
    } else {
      throw Exception('Failed to update message');
    }
  } catch (e) {
    print('problem with updating message: $e');
    return false;
  }
}

Future<int> fetchGetChatThreadIdByChildId (int childId, AuthProvider authProvider) async {
  final token = await authProvider.retrieveToken();

  try {
    final response = await http.get(
      Uri.parse('$apiUrl/api/FeedbackChat/GetChatThreadIdAndUserIdFromChildIdAndToken/$childId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final int chatThreadId = responseBody['chatThreadId'];
      return chatThreadId;
    } else {
      throw Exception('Failed to load chat thread id');
    }
  } catch (e) {
    print('problem with chat thread id: $e');
    rethrow;
  }
}


}