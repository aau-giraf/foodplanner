import 'package:flutter/material.dart';
import 'landing_page_children_madpakke.dart';
import '../services/fetch_children.dart';
import 'package:foodplanner/services/api_config.dart';

class TeacherLandingPage extends StatefulWidget {
  const TeacherLandingPage({super.key});


  static final ChildrenService childrenService = ChildrenService(apiUrl: ApiConfig.baseUrl);

  @override
  State<TeacherLandingPage> createState() => _LandingPageTeacherState();
}

class _LandingPageTeacherState extends State<TeacherLandingPage> {
  List<Map<String, String>> students = [];
  List<Map<String, String>> filteredStudents = [];
  List<Map<String, String>> schoolClasses = [];
  Set<String> selectedClassIds = {};
  Set<String> highlightedStudentIds = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createTemporaryDatabase();


    filteredStudents = students; // Initialize filteredStudents with all students
  }




  void createTemporaryDatabase() {
   // schoolClasses = TeacherLandingPage.childrenService.fetchChildrenData();
    /*[
      {'id': '1', 'name': 'Class A'},
      {'id': '2', 'name': 'Class B'},
      {'id': '3', 'name': 'Class C'},
      {'id': '4', 'name': 'Class D'},
      {'id': '5', 'name': 'Class E'},
    ];*/

    students = [
      {'id': '1', 'name': 'Alice', 'classId': '1'},
      {'id': '2', 'name': 'Bob', 'classId': '1'},
      {'id': '3', 'name': 'Charlie', 'classId': '1'},
      {'id': '4', 'name': 'David', 'classId': '1'},
      {'id': '5', 'name': 'Eve', 'classId': '1'},
      {'id': '6', 'name': 'Frank', 'classId': '2'},
      {'id': '7', 'name': 'Grace', 'classId': '2'},
      {'id': '8', 'name': 'Heidi', 'classId': '2'},
      {'id': '9', 'name': 'Ivan', 'classId': '2'},
      {'id': '10', 'name': 'Judy', 'classId': '2'},
      {'id': '11', 'name': 'Frank', 'classId': '3'},
      {'id': '12', 'name': 'Niaj', 'classId': '3'},
      {'id': '13', 'name': 'Olivia', 'classId': '3'},
      {'id': '14', 'name': 'Peggy', 'classId': '3'},
      {'id': '15', 'name': 'Frank', 'classId': '3'},
      {'id': '16', 'name': 'Trent', 'classId': '4'},
      {'id': '17', 'name': 'Victor', 'classId': '4'},
      {'id': '18', 'name': 'Frank', 'classId': '4'},
      {'id': '19', 'name': 'Xander', 'classId': '4'},
      {'id': '20', 'name': 'Yvonne', 'classId': '4'},
      {'id': '21', 'name': 'Zara', 'classId': '5'},
      {'id': '22', 'name': 'Quinn', 'classId': '5'},
      {'id': '23', 'name': 'Rita', 'classId': '5'},
      {'id': '24', 'name': 'Steve', 'classId': '5'},
      {'id': '25', 'name': 'Uma', 'classId': '5'},
    ];

    // Sort school classes alphabetically in ascending order
    schoolClasses.sort((a, b) => a['name']!.compareTo(b['name']!));

    // Sort students alphabetically in ascending order
    students.sort((a, b) => a['name']!.compareTo(b['name']!));
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

  void navigateToStudentDetails(Map<String, String> student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildLandingPageMadpakke(student: student),
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
        title: const Text('Vælg en elev'), // "Select a student"
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Students',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: filterStudents,
                  ),
                ),
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
                                .where((student) => student['classId'] == schoolClass['id'])
                                .map((student) {
                                  return ListTile(
                                    title: Text(
                                      student['name'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontWeight: highlightedStudentIds.contains(student['id'])
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: highlightedStudentIds.contains(student['id'])
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                    onTap: () => navigateToStudentDetails(student),
                                  );
                                })
                                .toList(),
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
    );
  }
}