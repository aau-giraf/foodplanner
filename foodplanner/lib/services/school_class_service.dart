import 'dart:convert';
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
}
