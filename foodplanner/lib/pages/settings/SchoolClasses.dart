import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
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
      }
    });
  }

  // Update the editing state
  void setEditingState(int classId, bool editing) {
    if (isEditing.containsKey(classId)) {
      setState(() {
        isEditing[classId] = editing;
      });
      print(isEditing);
    }
  }

  Widget cta(int schoolClassId) {
    return Row(
      children: [
        if (isEditing[schoolClassId]!) ...[
          IconButton(
            onPressed: () {
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
            onPressed: () {},
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
          SettingsWidget(
            title: 'Adminstrer klasser',
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
                    Text(
                      "Tilføj klasse",
                      style: AppTextStyles.mediumText.copyWith(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: true,
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
                title: !isEditing[schoolClass.classId]!
                    ? schoolClass.className
                    : '',
                type: SettingsType.items,
                leftIcon: SFIcons.sf_figure_2,
                cta: cta(schoolClass.classId),
              );
            },
          ),
        ],
      ),
    );
  }
}
