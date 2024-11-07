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
import 'package:foodplanner/components/text_field.dart';
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
  String updatedFirstName = '';
  String updatedLastName = '';


  @override
  void initState() {
    super.initState();

    firstNameController.text = TextEditingController(text: widget.child.firstName).text;
    lastNameController.text = TextEditingController(text: widget.child.lastName).text;
    updatedLastName = widget.child.lastName;
    selectedClassId = widget.child.classId.toString();

@override
void dispose() {
  firstNameController.dispose();
  lastNameController.dispose();
  super.dispose();
}

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
      'title': 'Fornavn: ',
      'showIcon': false,
      'isEditable': isEditingFirstName,
      'cta': Expanded(
        child: Row(
          children: <Widget>[
            Expanded(
              child: isEditingFirstName
              ? Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomTextField(
                  controller: firstNameController,
                  errorText: '',
                  hintText: 'Fornavn',
                  obscureText: false,
                  color: Colors.white,
                ),
              ): Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.child.firstName,
                    style: AppTextStyles.bigText,
                    
                  ),
                ],
              ),
            ),
            IconButton(
              icon: SFIcon(
                SFIcons.sf_pencil,
                color: AppColors.textPrimary,
                fontSize: 28,
              ),
              onPressed: () {
                setState(() {
                  isEditingFirstName = true;
                });
              },
            ),
          ],
        ),
      ),
      'showSpacer': false,
    },
    {
      'title': 'Efternavn: ',
      'showIcon': false,
      'isEditable': isEditingLastName,
      'cta': Expanded(
        child: Row(
          children: <Widget>[
            Expanded(
              child: isEditingLastName
              ? Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomTextField(
                  controller: lastNameController,
                  errorText: '',
                  hintText: 'Efternavn',
                  obscureText: false,
                  color: Colors.white,
                ),
              ): Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.child.lastName,
                    style: AppTextStyles.bigText,
                    
                  ),
                ],
              ),
            ),
            IconButton(
              icon: SFIcon(
                SFIcons.sf_pencil,
                color: AppColors.textPrimary,
                fontSize: 28,
              ),
              onPressed: () {
                setState(() {
                  isEditingLastName = true;
                });
              },
            ),
          ],
        ),
      ),
      'showSpacer': false,
    },
    {
      'title': 'Klasse',
      'showIcon': false,
      'isEditable': isEditingClass,
      'cta': ctaButtons(() {
        setState(() {
          isEditingClass = true;
        });
      }),
      'value': getClassName(widget.child.classId),
    },
    {
      'title': 'Forældre',
      'showIcon': false,
      'isEditable': false,
      'cta': ctaButtons(() {
        onPressed: () {
          Navigator.pushNamed(context, '/parent_profile', arguments: parent);
        };
      }),
      'value': '${parent.firstName} ${parent.lastName}',
      'divider': false,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
              Card(
                elevation: 2,
                color: AppColors.background,
                surfaceTintColor: AppColors.background,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        ...childProfileItem.map((item) {
                          return SettingsWidget(
                            showIcon: item['showIcon'],
                            title: '${item['title']}',
                            cta: item['cta'],
                            type: SettingsType.inlineItems,
                            isEditable: item['isEditable'],
                            divider: item['divider'] ?? true,
                            showSpacer: item['showSpacer'] ?? true,
                          );
                        }),
                      ],
                    ),
                  )
                ),
              )
            ]), 
          ),
        ],
      ),
    );
  }
}
