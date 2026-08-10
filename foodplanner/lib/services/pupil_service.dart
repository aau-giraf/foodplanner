import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:http/http.dart' as http;

class PupilService {
  final String apiUrl;

  PupilService({required this.apiUrl});

  Future<List<Pupil>> fetchPupil() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
        Uri.parse('$apiUrl/api/Admin/GetAllChildren'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        });

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body) as List<dynamic>;
      var responseList = jsonResponse
          .map((pupil) => Pupil.fromJson(pupil as Map<String, dynamic>))
          .toList();
      return responseList;
    } else if (response.statusCode == 403) {
      throw Exception('Du er ikke autherized til denne funktion');
    } else {
      throw Exception('Børn kunne ikke hentes');
    }
  }

  /// Returns all children linked to the logged-in parent. A parent can now have
  /// several children, so this returns a list.
  Future<List<Pupil>> fetchPupilsByParent() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
      Uri.parse('$apiUrl/api/Childrens/GetChildrenByParentId'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((child) => Pupil.fromJson(child as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load child data');
    }
  }

  /// Loads the record of the currently logged-in child. Children are now their
  /// own user accounts, so we resolve their id from the logged-in user and then
  /// fetch the matching child record.
  Future<Pupil> fetchOwnChild() async {
    final user = await UserService(apiUrl: apiUrl).fetchLoggedInUser();
    return getByPupilId(user.id);
  }

  /// Creates a child as a separate user account. Requires the logged-in parent's
  /// JWT; the backend links the new child to the parent.
  Future<http.Response> createPupil(String firstName, String lastName,
      String email, String password, int classId) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.post(
      Uri.parse('$apiUrl/api/Users/CreateUserChildren'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(<String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'classId': classId,
      }),
    );
    return response;
  }

  Future<http.Response> updatePupil(int id, String firstName, String lastName,
      int? parentId, int classId) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.put(
      Uri.parse('$apiUrl/api/Admin/UpdateChild'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(<String, dynamic>{
        'childId': id,
        'firstName': firstName,
        'lastName': lastName,
        if (parentId != null) 'parentId': parentId,
        'classId': classId,
      }),
    );

    return response;
  }

  /// Deletes a child. A child is now a user, so deleting the user (which
  /// cascades to the child record) is the correct operation.
  Future<http.Response> deletePupil(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.delete(
      Uri.parse('$apiUrl/api/Admin/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );

    return response;
  }

  Future<Pupil> getByPupilId(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
        Uri.parse('$apiUrl/api/Childrens/GetChildFromChildId/$id'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pupil.fromJson(data);
    } else {
      throw Exception('Failed to load child data');
    }
  }
}
