import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/child.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/components/settings_header.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


class ChildProfile extends StatefulWidget {
  final Child child;
  const ChildProfile({super.key, required this.child});

  static final ChildService childService = ChildService(apiUrl: ApiConfig.baseUrl);
  static final SchoolClassService schoolClassService = SchoolClassService(apiUrl: ApiConfig.baseUrl);
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);


  @override
  ChildProfileState createState() => ChildProfileState();
}

class ChildProfileState extends State<ChildProfile> with SingleTickerProviderStateMixin{
  List<SchoolClass> schoolClasses = [];
  User parent = User(id: 0, email: 'Unknown', firstName: 'Unknown', lastName: 'Unknown', role: 'Unknown');
  bool isEditingFirstName = false;
  bool isEditingLastName = false;
  bool isEditingClass = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  String? selectedClassId;

  @override
  void initState() {
    super.initState();

    firstNameController.text = widget.child.firstName;
    lastNameController.text = widget.child.lastName;
    selectedClassId = widget.child.classId.toString();



    ChildProfile.schoolClassService.fetchAllClasses().then((result) {
      setState(() {
        schoolClasses = result;
      });
    }).catchError((error) {
      throw(error);
    });

    ChildProfile.userService.fetchUser(widget.child.parentId).then((result) {
      setState(() {
        parent = result;
      });
    }).catchError((error) {
      throw(error);
    });

  }


  String getClassName(int classId){
      final schoolClass = schoolClasses.firstWhere((schoolClass) => schoolClass.classId == classId, orElse: () => SchoolClass(classId: 0, className: 'Unknown'));
      return schoolClass.className;
    }

  List<Map<String, dynamic>> get childProfileItem => [
    {
      'title': 'Fornavn',
      'showIcon': false,
      'isEditable': isEditingFirstName,
      'cta': ctaButtons(() {
        setState(() {
          isEditingFirstName = true;
        });
      }),
      'value': widget.child.firstName,
    },
    {
      'title': 'Efternavn',
      'showIcon': false,
      'isEditable': isEditingLastName,
      'cta': ctaButtons(() {
        setState(() {
          isEditingLastName = true;
        });
      }),
      'value': widget.child.lastName,
    },
  ];


  Widget ctaButtons(VoidCallback onPressed) {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: SFIcon(
            SFIcons.sf_pencil,
            color: AppColors.textPrimary,
            fontSize: 28,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: NavBar(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Administrer børn',
          style: AppTextStyles.headline4,
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SettingsHeader(
            icon: SFIcons.sf_figure_and_child_holdinghands,
            title: '${widget.child.firstName}s',
            subtitle: 'Her kan du redigere ${widget.child.firstName}s profil og klasse. ',
          ),
          Card(
            elevation: 2,
            color: AppColors.background,
            surfaceTintColor: AppColors.background,
            child: Center(
              child: Center(
                child: Padding(
                  padding: const EdgeInsects.symmetric(vertical: 10),
                  child: col,
                )
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                
                ...childProfileItem.map((item) {
                  return SettingsWidget(
                    leftIcon: SFIcons.sf_person,
                    showIcon: item['showIcon'],
                    title: '${item['title']} - ${item['value']}',
                    cta: item['cta'],
                    type: SettingsType.inlineItems,
                    isEditable: item['isEditable'],
                  );
                }),
                SettingsWidget(
                  leftIcon: SFIcons.sf_person,
                  title: 'Fornavn - ${widget.child.firstName}',
                  cta: ctaButtons(() {
                    setState(() {
                      isEditingFirstName = true;
                    });
                  }),
                  type: SettingsType.items,
                  showIcon: false,
                  isEditable: isEditingFirstName,
                ),
                SettingsWidget(
                  leftIcon: SFIcons.sf_person,
                  title: 'Efternavn - ${widget.child.lastName}',
                  cta: ctaButtons(() {
                    setState(() {
                      isEditingFirstName = true;
                    });
                  }),
                  type: SettingsType.items,
                  showIcon: false,
                  isEditable: isEditingLastName,
                ),
                
                SettingsWidget(
                  leftIcon: SFIcons.sf_calendar,
                  title: 'Klasse - ${getClassName(widget.child.classId)}',
                  cta: ctaButtons(() {
                    setState(() {
                      isEditingFirstName = false;
                    });
                  }),
                  type: SettingsType.items,
                  showIcon: false,
                ),
                 SettingsWidget(
                  leftIcon: SFIcons.sf_calendar,
                  title: 'Forældre - ${parent.firstName} ${parent.lastName}',
                  cta: ctaButtons(() {
                    setState(() {
                      isEditingFirstName = false;
                    });
                  }),
                  type: SettingsType.items,
                  showIcon: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
