

import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';

import 'package:foodplanner/components/nav_bar.dart';

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
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/pages/admin_administration/EditClasses.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:http/http.dart' as http;

class SchoolClasses extends StatefulWidget {
  //final String apiUrl;
  static final SchoolClassService schoolClassService =
      SchoolClassService(apiUrl: ApiConfig.baseUrl);

  const SchoolClasses({super.key});

  @override
  State<SchoolClasses> createState() => _SchoolClasses();
}

class _SchoolClasses extends State<SchoolClasses> {
  Future<List<SchoolClass>> classesFuture =
      SchoolClasses.schoolClassService.fetchAllClasses();
  List<SchoolClass> schoolClasses = [];
  List<ChildWithClassname> students = [];
  List<ChildWithClassname> filteredStudents = [];
  Set<int> selectedClassIds = {};
  Set<String> highlightedStudentIds = {};

  TextEditingController searchController = TextEditingController();

  final _scrollController = ScrollController();

  final controller = TextEditingController();

  Map<int, bool> isEditing = {};
  Map<int, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    fetchChildrenData();
    classesFuture.then((classes) {
      setState(() {
        schoolClasses = classes;
      });
      // Initialize the Map with classIds
      for (var c in classes) {
        isEditing[c.classId] = false;
        controllers[c.classId] =
            TextEditingController(text: c.className);
      }
    });
  }

  /*Future<Child> GetChildrenByClassId (int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = http.get(
      Uri.parse('$apiUrl/api/Admin/GetAllChildrenClassesAsync'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      }
    );

    if(response.statusCode == 200){
      List<dynamic> jsonResponse = jsonDecode(reponse.body) as List<dynamic>;
      var responseList = jsonResponse.map((child) => Child.fromJson(child as Map<String, dynamic>)).toList();
      return responseList;
    } else if (response.statusCode == 403){
      throw Exception('Du er ikke autherized til denne funktion');
    } else {
      throw Exception('Børn kunne ikke hentes');
    }
  }*/

  Future<void> fetchChildrenData() async {
    try {
      print("UserRoles: ${UserRoles.fromString("Student")}");
      //print("Fetching children from API");
      students = await ChildService(apiUrl: ApiConfig.baseUrl).fetchChildrenInAllClass();
      print("Students: ${students}");
      //print("fetched ${students.length} children");
      print("Students.isEmpty: ${students.isEmpty}");
      if (students.isEmpty) {
        print("No children where fetched!");
      } else {
        for (var child in students) {
          print ("Child: ${child.firstName} ${child.lastName}, classId: ${child.classId}, className: ${child.className}");
        }
      }
      /*if(UserRoles.fromString("Student")) {
        
      }*/
      filteredStudents = students;

      setState(() {
        filteredStudents = students;
      });
    } catch (e) {
      print('Error fetching children: $e');
    }
  }

  /*Future<void> fetchChildrenData() async {
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

          final uniqueClasses = <int, String>{};
          for (var student in students) {
            if(student['classId'] != null && student['className'] != null) {
              final id = int.tryParse(student['classId']!) ?? -1;
              if (id > 0) uniqueClasses[id] = student['className']!;
            }
          }
          for (var entry in uniqueClasses.entries) {
            final exists = schoolClasses.any((c) => c.classId == entry.key);
            if (!exists) {
              schoolClasses.add(SchoolClass(classId: entry.key, className: entry.value));
            }
          }
          schoolClasses.sort((a,b) => a.className.compareTo(b.className));
        });
      } else {
        throw Exception('Failed to load children data');
      }
    } catch (e){
      print('Error fetching children data: $e');
    }
  }*/

  void toggleClassStudents(int classId) {
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
          final studentName = '${student.firstName} ${student.lastName}'.toLowerCase();
          return studentName.contains(lowerCaseQuery);
        }).toList();

        // Automatically expand the classes containing the searched students
        selectedClassIds.clear();
        for (var student in filteredStudents) {
          selectedClassIds.add(student.classId);
        }
      }
    });
  }

  void collapseAll() {
    setState(() {
      if (selectedClassIds.isEmpty) {
        selectedClassIds =
            schoolClasses.map((schoolClass) => schoolClass.classId).toSet();
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
    final messenger = ScaffoldMessenger.of(context);
    SchoolClasses.schoolClassService
        .createClass(controller.text)
        .then((newClass) {
      setState(() {
        schoolClasses.add(newClass);
        isEditing[newClass.classId] = false;
        controllers[newClass.classId] =
            TextEditingController(text: newClass.className);
        controller.clear();
      });

      messenger.showSnackBar(
        SnackBar(
          content: Text('Klassen ${newClass.className} er blevet tilføjet'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void updateClass(int classId) async {
     final messenger = ScaffoldMessenger.of(context);
    var error = await SchoolClasses.schoolClassService
        .updateClass(classId, controllers[classId]!.text);

    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(error['Message'][0]),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.errorText,
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text('Klassen er blevet opdateret'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void deleteClass(int classId) async {
    final messenger = ScaffoldMessenger.of(context);
    var error = await SchoolClasses.schoolClassService.deleteClass(classId);
    if (error != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(error['Message'][0]),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.errorText,
        ),
      );
    } else {
      setState(() {
        schoolClasses
            .removeWhere((schoolClass) => schoolClass.classId == classId.toString());
      });
      messenger.showSnackBar(
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
              itemCount: schoolClasses.length,
              itemBuilder: (context, index) {
                final schoolClass = schoolClasses[index]; 

                print("DEBUG: Cheking class ${schoolClass.className} (id ${schoolClass.classId})");

                final childrenInClass = students.where((child) => child.classId == schoolClass.classId).toList();

                print("Found ${childrenInClass.length} children in this class");

                return ExpansionTile(
                  title: Text(schoolClass.className),
                  tilePadding: const EdgeInsets.all(15),
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
                  children: [
                    if (childrenInClass.isNotEmpty)
                      ...childrenInClass.map((child){
                        print("Student: ${child.firstName} in ${child.className}");
                        return ListTile(
                          title: Text('${child.firstName} ${child.lastName}'),
                        );
                      }),
                    if (childrenInClass.isEmpty)
                      const ListTile(
                        title: Text("Ingen børn"),
                      ),

                    const ListTile(
                      title: Text("Tilføj barn"),
                    )
                  ]
                );
              }
              /*shrinkWrap: true,
              itemCount: schoolClasses.length,
              itemBuilder: (context, index) {
                final schoolClass = schoolClasses[index];
                final isLastClass = index == schoolClasses.length - 1;
                final classStudents = students
                    .where((student) => student['classId'] == schoolClass['id'])
                    .toList();
                final filteredClassStudents = filteredStudents
                    .where((student) => student['classId'] == schoolClass['id'])
                    .toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomListItem(
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
                              key: ValueKey(student['id']),
                              title: student['name'] ?? 'Unknown',
                              isHighlighted: highlightedStudentIds
                                  .contains(student['id']),
                              isLastItem: isLastStudentInLastClass,
                              onTap: () => navigateToStudentDetails(student),
                              isTapped: highlightedStudentIds
                                  .contains(student['id']),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                );
              },*/
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
          ),
          TextButton(
            onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditClasses()
                    ),
                  );
                },
            child: Text(
              "Redigere klasse",
              style: AppTextStyles.mediumText.copyWith(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w600,
              ),
            )
          )
        ],
      ),
      bottomNavigationBar: NavBar(),
    );
  }
} 
