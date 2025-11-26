

import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/Custom_List_Item.dart';
import 'package:foodplanner/components/popup_box.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/child_with_classname.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/models/child.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:go_router/go_router.dart';

class SchoolClasses extends StatefulWidget {
  static final SchoolClassService schoolClassService =
      SchoolClassService(apiUrl: ApiConfig.baseUrl);

  const SchoolClasses({super.key});

  @override
  State<SchoolClasses> createState() => _SchoolClasses();
}

class _SchoolClasses extends State<SchoolClasses> {
  Future<List<SchoolClass>> classesFuture =
      SchoolClasses.schoolClassService.fetchAllClasses();
  List<Map<String, String>> schoolClasses = [];
  List<SchoolClass> schoolClass = [];
  List<Map<String, String?>> students = [];
  List<Map<String, String?>> filteredStudents = [];
  Set<String> selectedClassIds = {};
  Set<String> highlightedStudentIds = {};
  TextEditingController searchController = TextEditingController();

  final controller = TextEditingController();

  Map<int, bool> isEditing = {};
  Map<int, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    fetchChildrenData();
    classesFuture.then((classes) {
      setState(() {
      });
      // Initialize the Map with classIds
      for (var schoolClass in classes) {
        isEditing[schoolClass.classId] = false;
        controllers[schoolClass.classId] =
            TextEditingController(text: schoolClass.className);
      }
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
          students = data.map((ChildrenGetAllDTO e) => {
            'id': e.childId.toString(),
            'name': '${e.firstName} ${e.lastName}',
            'classId': e.classId.toString(),
            'className': e.className,
          }).toList();
          filteredStudents = students;

          final uniqueClasses = <String, String>{};
          for (var student in students) {
            uniqueClasses[student['classId']!] = student['className']!;
          }
          schoolClasses = uniqueClasses.entries.map((entry) => {'id': entry.key, 'name': entry.value}).toList();
          schoolClasses.sort((a,b) => a['name']!.compareTo(b['name']!));
        });
      } else {
        throw Exception('Failed to load children data');
      }
    } catch (e){
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

  // Update the editing state
  void setEditingState(int classId, bool editing) {
    if (isEditing.containsKey(classId)) {
      setState(() {
        isEditing[classId] = editing;
      });
    }
  }

  void addClass() {
    SchoolClasses.schoolClassService
        .createClass(controller.text)
        .then((schoolClass) {
      setState(() {
        schoolClasses.add(schoolClass as Map<String, String>);
        isEditing[schoolClass.classId] = false;
        controllers[schoolClass.classId] =
            TextEditingController(text: schoolClass.className);
        controller.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Klassen ${schoolClass.className} er blevet tilføjet'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void updateClass(int classId) async {
    var error = await SchoolClasses.schoolClassService
        .updateClass(classId, controllers[classId]!.text);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error['Message'][0]),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.errorText,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Klassen er blevet opdateret'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void deleteClass(int classId) async {
    var error = await SchoolClasses.schoolClassService.deleteClass(classId);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error['Message'][0]),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.errorText,
        ),
      );
    } else {
      setState(() {
        schoolClasses
            .removeWhere((schoolClass) => schoolClass.classId == classId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Klassen er blevet slettet'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget cta(int schoolClassId) {
    return Row(
      children: [
        if (isEditing[schoolClassId]!) ...[
          IconButton(
            onPressed: () {
              updateClass(schoolClassId);
              setEditingState(schoolClassId, false);
            },
            icon: SFIcon(
              SFIcons.sf_checkmark_square_fill,
              color: Colors.green,
              fontSize: 36,
            ),
            padding: EdgeInsets.zero,
          ),
        ] else ...[
          IconButton(
            onPressed: () {
              setEditingState(schoolClassId, !isEditing[schoolClassId]!);
            },
            icon: SFIcon(
              SFIcons.sf_pencil,
              color: Colors.blue.shade700,
              fontSize: 36,
            ),
            padding: EdgeInsets.zero,
          ),
          IconButton(
            onPressed: () {
              //deleteClass(schoolClassId);
              showIPhonePopupBox(
                context: context,
                title: 'Slet klasse',
                message: 'Er du sikker på, at du vil slette denne klasse?',
                confirmText: 'Ja',
                cancelText: 'Nej',
                onConfirm: () {
                  deleteClass(schoolClassId);
                  Navigator.of(context).pop(); // Close the popup
                },
                onCancel: () {
                  Navigator.of(context).pop(); // Close the popup
                },
              );
            },
            icon: SFIcon(
              SFIcons.sf_x_square_fill,
              color: AppColors.errorText,
              fontSize: 36,
            ),
            padding: EdgeInsets.zero,
          ),
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                SFIcon(SFIcons.sf_chevron_backward),
                SizedBox(width: 10),
                Text(
                  'Indstillinger',
                  style: AppTextStyles.headline4,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 200,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Text(
            'Administrér klasser',
            style: TextStyle(fontSize: 36),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              elevation: 2,
              color: AppColors.background,
              surfaceTintColor: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: CustomTextField(
                        controller: controller,
                        errorText: "",
                        hintText: "Skriv klasse navn",
                        type: TextFieldType.smallTextField,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
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
                    
                      /*child: SettingsWidget(
                        title: controllers[schoolClass.classId]!.text,
                        type: SettingsType.items,
                        cta: cta(schoolClass.classId),
                        isEditable: isEditing[schoolClass.classId]!,
                        controller: controllers[schoolClass.classId],
                      )*/            
          TextButton(
          onPressed: addClass,
          child: Text(
            "Tilføj klasse",
            style: AppTextStyles.mediumText.copyWith(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          )
          )
        ],
      ),
    );
  }
}

extension on Map<String, String> {
  get classId => null;
}
