import 'dart:convert';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/models/pupil_with_classname.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:http/http.dart' as http;

class ChildService {
  final String apiUrl;

  ChildService({required this.apiUrl});

  Future<List<Pupil>> fetchChild() async {
    final jwtToken = await AuthProvider().retrieveToken();
    print(jwtToken);

    final response = await http.get(
        Uri.parse('$apiUrl/api/Childrens/GetAll'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        });

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Pupil> pupils = jsonResponse.map((json) => Pupil.fromChildJson(json as Map<String, dynamic>)).toList();
      return pupils;
    } else {
      throw Exception('Kunne ikke hente Børn');
    }
  }

  Future<Pupil> fetchChildById() async {
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

  Future<http.Response> createChild(
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

  Future<http.Response> updateChild(int id, String firstName, String lastName,
      int parentId, int classId) async {
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

  Future<http.Response> deleteChild(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.delete(
      Uri.parse('$apiUrl/api/Childrens/Delete/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );

    return response;
  }

  Future<Pupil> GetByChildId(int id) async {
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

   Future<List<PupilWithClassname>> fetchChildrenInAllClass() async {
    try {
      List<dynamic> jsonList = [];
      final jwtToken = await AuthProvider().retrieveToken();


      var apiClient = ApiClient(basePath: ApiConfig.baseUrl);
      apiClient.addDefaultHeader('Authorization', 'Bearer $jwtToken');

      final childrensApi = ChildrensApi(apiClient);

      final response = await childrensApi.apiChildrensGetAllChildrenClassesGetWithHttpInfo(); 

      print("RAW API RESPONSE: ${response.body}");


      jsonList = response.body is List ? response.body : json.decode(response.body);

      print("SEE HERE IS THE LIST: $jsonList");

      for (var item in jsonList) {
        print("Child fetched: $item");
      }

      return jsonList.map((jsonItem) => PupilWithClassname.fromJson(jsonItem)).toList();
    } catch (e) {
      print('Error fetching children: $e');
      return[];
    }
  }

}
