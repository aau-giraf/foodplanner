import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/components/custom_list_item.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/models/user.dart' as model;
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/models/user_roles.dart';

class TeacherLandingPage extends StatefulWidget {
  const TeacherLandingPage({super.key});

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

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
  model.User teacher = model.User(
      id: 0,
      email: 'Unknown',
      firstName: 'Unknown',
      lastName: 'Unknown',
      role: UserRoles.empty(),
      archived: false);

  @override
  void initState() {
    super.initState();
    fetchChildrenData();
    fetchUser();
  }

  Future<void> fetchUser() async {
    final userInfo = await TeacherLandingPage.userService.fetchLoggedInUser();
    setState(() {
      teacher = userInfo;
    });
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
     developer.log('Error fetching children data: $e');
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

    GoRouter.of(context).go('/student-details', extra: filteredStudent);
  }

  void filterStudents(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      if (lowerCaseQuery.isEmpty) {
        filteredStudents = students;
        selectedClassIds.clear();
      } else {
        filteredStudents = students.where((student) {
          final studentName = student['name']!.toLowerCase();
          return studentName.contains(lowerCaseQuery);
        }).toList();

        // Automatically expand the classes containing the searched students
        selectedClassIds.clear();
        if (filteredStudents.isNotEmpty) {
          for (var student in filteredStudents) {
            final classId = student['classId'];
            selectedClassIds.add(classId!);
          }
        }
      }
    });
  }

  void collapseAll() {
    setState(() {
      if (selectedClassIds.isEmpty) {
        selectedClassIds =
            schoolClasses.map((schoolClass) => schoolClass['id']!).toSet();
      } else {
        selectedClassIds.clear();
        searchController.clear();
        filteredStudents = students;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Velkommen ${teacher.firstName} ${teacher.lastName}',
            style: AppTextStyles.headline4,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
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
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: SearchField(
                    controller: searchController,
                    hintText: 'Søg efter elev',
                    onChanged: filterStudents,
                  ),
                ),
                const SizedBox(width: 0),
                Expanded(
                  child: CustomButton(
                    onTab: collapseAll,
                    text: selectedClassIds.isEmpty ? 'Åben alle' : 'Luk alle',
                    customHeight: 50,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 2,
                color: AppColors.background,
                surfaceTintColor: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Klasser:',
                        style: AppTextStyles.bigText
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: schoolClasses.length,
                        itemBuilder: (context, index) {
                          final schoolClass = schoolClasses[index];
                          final isLastClass = index == schoolClasses.length - 1;
                          final classStudents = students
                              .where((student) =>
                                  student['classId'] == schoolClass['id'])
                              .toList();
                          final filteredClassStudents = filteredStudents
                              .where((student) =>
                                  student['classId'] == schoolClass['id'])
                              .toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomListItem(
                                leftIcon: SFIcons.sf_figure_2,
                                leftIconStyle: TextStyle(fontSize: 22),
                                title: schoolClass['name'] ?? 'Unknown',
                                isHighlighted: false,
                                isLastItem: isLastClass,
                                onTap: () =>
                                    toggleClassStudents(schoolClass['id']!),
                                isTapped: selectedClassIds
                                    .contains(schoolClass['id']),
                              ),
                              if (selectedClassIds.contains(schoolClass['id']))
                                Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Column(
                                    children: (searchController.text.isEmpty
                                            ? classStudents
                                            : filteredClassStudents)
                                        .map((student) {
                                      final isLastStudentInLastClass =
                                          isLastClass &&
                                              classStudents.indexOf(student) ==
                                                  classStudents.length - 1;
                                      return CustomListItem(
                                        leftIcon: SFIcons.sf_figure_child,
                                        key: ValueKey(student['id']),
                                        title: student['name'] ?? 'Unknown',
                                        isHighlighted: highlightedStudentIds
                                            .contains(student['id']),
                                        isLastItem: isLastStudentInLastClass,
                                        onTap: () =>
                                            navigateToStudentDetails(student),
                                        isTapped: highlightedStudentIds
                                            .contains(student['id']),
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
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
