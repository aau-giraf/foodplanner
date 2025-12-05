import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/card_container.dart';
import 'package:foodplanner/components/custom_app_bar.dart';

import 'package:foodplanner/components/nav_bar.dart';

import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/Custom_List_Item.dart';

import 'package:foodplanner/components/popup_box.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/child_with_classname.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/pages/admin_administration/AddPupil.dart';
import 'package:foodplanner/pages/admin_administration/EditClasses.dart';
import 'package:foodplanner/pages/admin_administration/EditPupilInfo.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:http/http.dart' as http;

class SchoolClasses extends StatefulWidget {
  //final String apiUrl;
  static final SchoolClassService schoolClassService =
      SchoolClassService(apiUrl: ApiConfig.baseUrl);
      
  static final ChildService childService = 
      ChildService(apiUrl: ApiConfig.baseUrl);

  const SchoolClasses({super.key});

  @override
  State<SchoolClasses> createState() => _SchoolClasses();
}

class _SchoolClasses extends State<SchoolClasses> {
  Future<List<SchoolClass>> classesFuture =
      SchoolClasses.schoolClassService.fetchAllClasses();
  Set<int> selectedClassIds = {};
  Set<String> highlightedStudentIds = {};
  List<Pupil> children = [];
  List<SchoolClass> schoolClasses = [];
  List<Pupil> filteredChildren = [];

  TextEditingController searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _searchFieldController = TextEditingController();

  final controller = TextEditingController();

  Map<int, bool> isEditing = {};
  Map<int, TextEditingController> controllers = {};

   @override
  void dispose() {
    _searchFieldController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchChildren();
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

    SchoolClasses.schoolClassService.fetchAllClasses().then((result) {
      setState(() {
        schoolClasses = result;
      });
    }).catchError((error) {
      throw (error);
    });

    searchController.addListener(_filterChildren);
  }

  void fetchChildren() {
    SchoolClasses.childService.fetchChild().then((result) {
      setState(() {
        children = result;
        filteredChildren = result;
      });
    }).catchError((error) {
      throw (error);
    });
  }

  List<Pupil> filterChildrenByClass(int schoolClassId) {
    List<Pupil> childrenInClass = children.where((child) => child.classId == schoolClassId).toList();
    return childrenInClass;
  }

  String getClassName(int classId) {
    final schoolClass = schoolClasses.firstWhere(
        (schoolClass) => schoolClass.classId == classId,
        orElse: () => SchoolClass(classId: 0, className: 'Unknown'));
    return schoolClass.className;
  }

  void _filterChildren() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredChildren = children.where((child) {
        final name = '${child.firstName} ${child.lastName}'.toLowerCase();
        final className = getClassName(child.classId).toLowerCase();
        return name.contains(query) || className.contains(query);
      }).toList();
    });
  }

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

  void collapseAll() {
    setState(() {
      if (selectedClassIds.isEmpty) {
        selectedClassIds =
            schoolClasses.map((schoolClass) => schoolClass.classId).toSet();
      } else {
        selectedClassIds.clear();
        searchController.clear();
        filteredChildren = children;
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
    /*IconButton(
            onPressed: () {
              //deleteClass(schoolClassId);
              showIPhonePopupBox(
                context: context,
                title: 'Slet klasse',
                message: 'Er du sikker på, at du vil slette denne klasse?',
                confirmText: 'Ja',
                cancelText: 'Nej',
                onConfirm: () {
                  SchoolClasses.schoolClassService
                    .createClass(controller.text)
                    .then((newClass) {
                  setState(() {
                    schoolClasses.add(newClass);
        isEditing[newClass.classId] = false;
        controllers[newClass.classId] =
            TextEditingController(text: newClass.className);
        controller.clear();
      }); // Close the popup
                },
                onCancel: () {
                  Navigator.of(context).pop(); // Close the popup
                },
              );
            },
   */
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

  bool showSearchDropdown = false;
  bool hideSearchDropdown = true;

  void searchFunction(String input){
    setState(() {
      filteredChildren = children.where((child) {
        // pass both strings as lowercase to ensure case-insensitivity
        final fullName = "${child.firstName} ${child.lastName}".toLowerCase(); 
        final className = getClassName(child.classId).toLowerCase();
        final searchInput = input.toLowerCase();
        return fullName.contains(searchInput) || className.contains(searchInput); // return all elements where the input is part of the full name
      }).toList()

      ..sort((a,b) => ('${a.firstName} ${a.lastName}').compareTo('${b.firstName} ${b.lastName}'));

      showSearchDropdown = input.isNotEmpty;

    });
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
      appBar: CustomAppBar(
        title: "Administrer \n skole"
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: CardContainer(
                clipBehavior: Clip.antiAlias,
                color: AppColors.background,
                childWidget: Column(
                  children: [
                    SearchField(
                      controller: _searchFieldController, 
                      hintText: "Søg i alle børn og klasser",
                      onChanged: searchFunction,
                      borderRadius: 30, 
                      backgroundColor: Colors.white,
                      horizontalPadding: 5, 
                      verticalPadding: 5, 
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textFieldBorderFocus.withAlpha(100),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    if(showSearchDropdown)
                      Container(
                        constraints: BoxConstraints(maxHeight: 250),
                        decoration: BoxDecoration(
                          color: AppColors.textFieldBackground,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredChildren.length,
                          itemBuilder: (context, index) {
                            final child = filteredChildren[index];
                            return ListTile(
                              title: Text("${child.firstName} ${child.lastName}"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => EditPupilInfo(pupil: child)),
                                );
                              },

                            );

                          }
                        )
                      )
                    else
                    Expanded(
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          itemCount: schoolClasses.length,
                          itemBuilder: (context, index) {
                            final schoolClass = schoolClasses[index]; 
                            print("DEBUG: Cheking class ${schoolClass.className} (id ${schoolClass.classId})");
                            List<Pupil> childrenInClass = filterChildrenByClass(schoolClass.classId);
                            print("Found ${childrenInClass.length} children in this class");
                            return ExpansionTile(
                              title: Text(schoolClass.className),
                              tilePadding: const EdgeInsets.all(15),
                              collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
                              children: [
                                if (childrenInClass.isNotEmpty)
                                  ...childrenInClass.map((child){
                                  print("Student: ${child.firstName} in ${child.classId}");
                                  return ListTile(
                                    title: Text('${child.firstName} ${child.lastName}'),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => EditPupilInfo(pupil: child)));
                                      }, icon: SFIcon(SFIcons.sf_pencil, color: Colors.black)),
                                  );
                                  }),
                                if (childrenInClass.isEmpty)
                                  const ListTile(
                                    title: Text("Ingen børn"),
                                  ),
                                  
                                ListTile(
                                  onTap:() {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => AddPupil()
                                    ),);
                                  },
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Tilføj barn",
                                          style: AppTextStyles.mediumText.copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8,),
                                      Icon(Icons.add_reaction)
                                    ]
                                  )
                                )
                              ]
                            );
                          }
                        )
                      )
                    )
                  ]
                ),
              )
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(177,59),
                  ),
                  onPressed: addClass,
                  child: Text(
                      "Tilføj klasse",
                      style: AppTextStyles.mediumText.copyWith(
                        color: Colors.black,
                        backgroundColor: AppColors.background
                      ),
                  )
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size(177,59),
                    iconColor: AppColors.background
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditClasses()
                      ),
                    );
                  },
                  child: Text(
                    "Redigér klasse",
                    style: AppTextStyles.mediumText.copyWith(
                      color: Colors.black,
                      backgroundColor: AppColors.background
                    ),
                  )
                ),
              ],
            )
          ]
        )
      ),
      bottomNavigationBar: NavBar(),
    );
  }
} 

                      /*child: SettingsWidget(
                        title: controllers[schoolClass.classId]!.text,
                        type: SettingsType.items,
                        cta: cta(schoolClass.classId),
                        isEditable: isEditing[schoolClass.classId]!,
                        controller: controllers[schoolClass.classId],
                      )*/    