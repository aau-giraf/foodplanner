import 'dart:convert';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/services/api_config.dart';
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

  Future<Pupil> fetchPupilById() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
      Uri.parse('$apiUrl/api/Childrens/GetChildrenByParentId'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pupil.fromJson(data);
    } else {
      throw Exception('Failed to load child data');
    }
  }

  Future<http.Response> createPupil(
      String firstName, String lastName, int classId) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.post(
      Uri.parse('$apiUrl/api/Childrens/Create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'classId': classId.toString(),
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
        'ChildId': id,
        'firstName': firstName,
        'lastName': lastName,
        'parentId': parentId,
        'classId': classId,
      }),
    );

    return response;
  }

  Future<http.Response> updatePupilsClass(int id, int classId) async {

    final jwtToken = await AuthProvider().retrieveToken();

    final response = await http.put(
      Uri.parse('$apiUrl/api/Admin/UpdateChild'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(<String, dynamic>{
        'ChildId': id,
        'classId': classId,
      }),
    );

    return response;
  }

  Future<http.Response> deletePupil(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.delete(
      Uri.parse('$apiUrl/api/Childrens/Delete/$id'),
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

  Future<List<Pupil>> fetchPupilByParent() async {
    List<dynamic> jsonList = [];
    final jwtToken = await AuthProvider().retrieveToken();

    var apiClient = ApiClient(basePath: ApiConfig.baseUrl);
    apiClient.addDefaultHeader('Authorization', 'Bearer $jwtToken');
    
    final childrensApi = ChildrensApi(apiClient);
    
    final response = await childrensApi.apiChildrensGetChildrenByParentIdGetWithHttpInfo(
      authorization: 'Bearer $jwtToken',
      );

    if (response.statusCode == 200) {
        jsonList = response.body is List
          ? response.body
          : json.decode(response.body);

        print(jsonList.toString()); // for debugging purposes
      return jsonList.map((jsonItem) => Pupil.fromChildJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to load children (status ${response.statusCode})');
    }
  }
}
