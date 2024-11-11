import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:http/http.dart' as http;

class SchoolClassService {
  final String apiUrl;

  SchoolClassService({required this.apiUrl});

  Future<List<SchoolClass>> fetchAllClasses() async {
    final response = await http.get(Uri.parse('$apiUrl/api/Classrooms/GetAll'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<SchoolClass> classes = SchoolClass.fromJsonList(jsonResponse);
      return classes;
    } else {
      throw Exception('Kunne ikke hente Klasser');
    }
  }

  Future<SchoolClass> createClass(String className) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.post(
      Uri.parse('$apiUrl/api/Classrooms/Create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(<String, String>{
        'className': className,
      }),
    );

    if (response.statusCode == 201) {
      int schoolClassID = int.parse(response.body);
      return SchoolClass(classId: schoolClassID, className: className);
    } else {
      throw Exception('Kunne ikke oprette klasse');
    }
  }

  Future<void> updateClass(int classId, String className) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.put(
      Uri.parse('$apiUrl/api/Classrooms/Update/$classId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode(<String, String>{
        'className': className,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Kunne ikke opdatere klasse');
    }
  }

  Future<dynamic> deleteClass(int classId) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.delete(
      Uri.parse('$apiUrl/api/Classrooms/Delete/$classId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 400) {
      print("Error " + response.body);
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } else if (response.statusCode != 200) {
      print("hejsa");
      return {'Message': 'Kunne ikke slette klasse'};
    }
  }
}
