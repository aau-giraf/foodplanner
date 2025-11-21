import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/components/popup_box.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/school_class_service.dart';

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
  List<SchoolClass> schoolClasses = [];

  final controller = TextEditingController();

  Map<int, bool> isEditing = {};
  Map<int, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    classesFuture.then((classes) {
      setState(() {
        schoolClasses = classes;
      });
      // Initialize the Map with classIds
      for (var schoolClass in classes) {
        isEditing[schoolClass.classId] = false;
        controllers[schoolClass.classId] =
            TextEditingController(text: schoolClass.className);
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
        .then((schoolClass) {
      setState(() {
        schoolClasses.add(schoolClass);
        isEditing[schoolClass.classId] = false;
        controllers[schoolClass.classId] =
            TextEditingController(text: schoolClass.className);
        controller.clear();
      });

      messenger.showSnackBar(
        SnackBar(
          content: Text('Klassen ${schoolClass.className} er blevet tilføjet'),
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
            .removeWhere((schoolClass) => schoolClass.classId == classId);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsWidget(
              title: 'Administrer klasser',
              type: SettingsType.header,
              leftIcon: SFIcons.sf_figure_2,
              subTitle: 'Tilføj, rediger og slet klasser',
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
                      TextButton(
                        onPressed: addClass,
                        child: Text(
                          "Tilføj klasse",
                          style: AppTextStyles.mediumText.copyWith(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                          softWrap: true,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
            ),
            ...schoolClasses.map(
              (schoolClass) {
                return SettingsWidget(
                  title: controllers[schoolClass.classId]!.text,
                  type: SettingsType.items,
                  leftIcon: SFIcons.sf_figure_2,
                  cta: cta(schoolClass.classId),
                  isEditable: isEditing[schoolClass.classId]!,
                  controller: controllers[schoolClass.classId],
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
