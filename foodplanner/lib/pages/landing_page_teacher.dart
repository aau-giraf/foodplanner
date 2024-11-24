import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'landing_page_children_madpakke.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class TeacherLandingPage extends StatefulWidget {
  const TeacherLandingPage({super.key});

  @override
  State<TeacherLandingPage> createState() => _LandingPageTeacherState();
}

class _LandingPageTeacherState extends State<TeacherLandingPage> {
  List<Map<String, String?>> students = [];
  List<Map<String, String?>> filteredStudents = [];
  List<Map<String, String>> schoolClasses = [];
  Set<String> selectedClassIds = {};
  Set<String> highlightedStudentIds = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchChildrenData();
  }

  Future<void> fetchChildrenData() async {
    try {
      String? jwtToken = await AuthProvider().retrieveToken();
      var apiClient = ApiClient(basePath: ApiConfig.baseUrl);
      apiClient.addDefaultHeader('Authorization', 'Bearer $jwtToken');
      final childrensApi = ChildrensApi(apiClient);
      final List<ChildrenGetAllDTO>? data =
          await childrensApi.apiChildrensGetAllChildrenClassesGet();

      if (data != null) {
        setState(() {
          students = data
              .map((ChildrenGetAllDTO e) => {
                    'id': e.childId.toString(),
                    'name': '${e.firstName} ${e.lastName}',
                    'classId': e.classId.toString(),
                    'className': e.className,
                  })
              .toList();
          filteredStudents = students;

          // Extract unique class IDs and names from students
          final uniqueClasses = <String, String>{};
          for (var student in students) {
            uniqueClasses[student['classId']!] = student['className']!;
          }
          schoolClasses = uniqueClasses.entries
              .map((entry) => {'id': entry.key, 'name': entry.value})
              .toList();

          // Sort school classes alphabetically in ascending order
          schoolClasses.sort((a, b) => a['name']!.compareTo(b['name']!));
        });
      } else {
        throw Exception('Failed to load children data');
      }
    } catch (e) {
      print('Error fetching children data: $e');
    }
  }

  void toggleClassStudents(String classId) {
    setState(() {
      if (selectedClassIds.contains(classId)) {
        selectedClassIds.remove(classId);
      } else {
        selectedClassIds.add(classId);
      }
    });
  }

  void navigateToStudentDetails(Map<String, String?> student) {
    // Filter out null values from the student map
    final filteredStudent =
        student.map((key, value) => MapEntry(key, value ?? ''));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ChildLandingPageMadpakke(student: filteredStudent),
      ),
    );
  }

  void filterStudents(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredStudents = students;
        highlightedStudentIds.clear();
      });
      return;
    }

    final suggestions = students.where((student) {
      final studentName = student['name']!.toLowerCase();
      final input = query.toLowerCase();
      return studentName.contains(input);
    }).toList();

    setState(() {
      filteredStudents = suggestions;

      // Automatically expand the classes containing the searched students
      highlightedStudentIds.clear();
      if (suggestions.isNotEmpty) {
        for (var student in suggestions) {
          final classId = student['classId'];
          selectedClassIds.add(classId!);
          highlightedStudentIds.add(student['id']!);
        }
      }
    });
  }

  void collapseAll() {
    setState(() {
      selectedClassIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Velkommen',
            style: AppTextStyles.headline4,
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SettingsWidget(
              leftIcon: SFIcons.sf_figure_and_child_holdinghands,
              title: 'Vælg en elev for at forsætte',
              subTitle:
                  'Her kan du vælge eller søge efter elever i de repektive klasser',
              type: SettingsType.header,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                /*Expanded(
                  child: SearchField(
                    controller: searchController,
                    hintText: 'Søg efter elev',
                    onChanged: filterStudents,
                  ),
                ),*/
                const SizedBox(width: 16.0),
                GestureDetector(
                  onTap: collapseAll,
                  child: Text(
                    'Collapse all',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: schoolClasses.length,
                itemBuilder: (context, index) {
                  final schoolClass = schoolClasses[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(schoolClass['name'] ?? 'Unknown'),
                        onTap: () => toggleClassStudents(schoolClass['id']!),
                      ),
                      if (selectedClassIds.contains(schoolClass['id']))
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            children: students
                                .where((student) =>
                                    student['classId'] == schoolClass['id'])
                                .map((student) {
                              return ListTile(
                                key: ValueKey(student[
                                    'id']), // Add a unique key to each ListTile
                                title: Text(
                                  student['name'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontWeight: highlightedStudentIds
                                            .contains(student['id'])
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: highlightedStudentIds
                                            .contains(student['id'])
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                ),
                                onTap: () => navigateToStudentDetails(student),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
