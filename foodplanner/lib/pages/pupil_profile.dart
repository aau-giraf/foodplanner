import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/models/schoolClass.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:foodplanner/pages/choose_guardian.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/models/user_roles.dart';

class PupilProfile extends StatefulWidget {
  final Pupil pupil;
  final VoidCallback? onPupilChanged;
  const PupilProfile({super.key, required this.pupil, this.onPupilChanged});

  static final PupilService childService =
      PupilService(apiUrl: ApiConfig.baseUrl);
  static final SchoolClassService schoolClassService =
      SchoolClassService(apiUrl: ApiConfig.baseUrl);
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  PupilProfileState createState() => PupilProfileState();
}

class PupilProfileState extends State<PupilProfile>
    with SingleTickerProviderStateMixin {
  List<SchoolClass> schoolClasses = [];
  User guardian = User(
      id: 0,
      email: 'Unknown',
      firstName: 'Unknown',
      lastName: 'Unknown',
      role: UserRoles.empty(),
      archived: false);
  bool isEditingFirstName = false;
  bool isEditingLastName = false;
  bool isEditingClass = false;
  bool isEditingGuardians = false;
  bool hasChanges = false;
  bool classChanges = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  String? selectedClassId;
  String? initialClassId;
  String updatedFirstName = '';
  String updatedLastName = '';
  int? selectedGuardianId;
  int? initialGuardianId;
  User? selectedGuardian;

  void onFieldChanged() {
    setState(() {
      hasChanges = true;
    });
  }

  @override
  void initState() {
    super.initState();

    firstNameController.text =
        TextEditingController(text: widget.pupil.firstName).text;
    lastNameController.text =
        TextEditingController(text: widget.pupil.lastName).text;
    updatedFirstName = widget.pupil.firstName;
    updatedLastName = widget.pupil.lastName;
    selectedClassId = widget.pupil.classId.toString();
    initialClassId = widget.pupil.classId.toString();
    fetchGuardian();
    selectedGuardian = guardian;
    selectedGuardianId = widget.pupil.guardianId;
    initialGuardianId = widget.pupil.guardianId;

    PupilProfile.schoolClassService.fetchAllClasses().then((result) {
      setState(() {
        schoolClasses = result;
      });
    }).catchError((error) {
      throw (error);
    });
  }

  void fetchGuardian() {
    PupilProfile.userService.fetchUser(widget.pupil.guardianId).then((result) {
      setState(() {
        guardian = result;
        selectedGuardian = result;
      });
    }).catchError((error) {
      throw (error);
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  String getClassName(int classId) {
    final schoolClass = schoolClasses.firstWhere(
        (schoolClass) => schoolClass.classId == classId,
        orElse: () => SchoolClass(classId: 0, className: 'Unknown'));
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
                            onChanged: (value) {
                              updatedLastName = value;
                              onFieldChanged();
                            },
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.pupil.firstName,
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
                    if (isEditingFirstName) {
                      setState(() {
                        isEditingFirstName = false;
                        firstNameController.text = widget.pupil.firstName;
                        if (!isEditingLastName &&
                            !isEditingClass &&
                            !classChanges) {
                          hasChanges = false;
                        }
                      });
                    } else {
                      setState(() {
                        isEditingFirstName = true;
                      });
                    }
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
                            onChanged: (value) {
                              updatedLastName = value;
                              onFieldChanged();
                            },
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              widget.pupil.lastName,
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
                    if (isEditingLastName) {
                      setState(() {
                        isEditingLastName = false;
                        lastNameController.text = widget.pupil.lastName;
                        if (!isEditingFirstName &&
                            !isEditingLastName &&
                            !isEditingClass &&
                            !classChanges) {
                          hasChanges = false;
                        }
                      });
                    } else {
                      setState(() {
                        isEditingLastName = true;
                      });
                    }
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
          'cta': Container(
            height: 35,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(10), // Set the desired border radius
              color: Colors
                  .transparent, // Ensure the container itself is transparent
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Vælg klasse',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                items: schoolClasses
                    .map((SchoolClass schoolClass) => DropdownMenuItem<String>(
                          value: schoolClass.classId.toString(),
                          child: Text(
                            schoolClass.className,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                value: selectedClassId,
                onChanged: (String? value) {
                  setState(() {
                    if (value == initialClassId) {
                      isEditingClass = false;
                      classChanges = false;
                      if (!isEditingFirstName &&
                          !isEditingLastName &&
                          !isEditingClass &&
                          !classChanges) {
                        hasChanges = false;
                      }
                      selectedClassId = value;
                      return;
                    }
                    selectedClassId = value;
                    onFieldChanged();
                    classChanges = true;
                  });
                },
                selectedItemBuilder: (BuildContext context) {
                  return schoolClasses.map((SchoolClass schoolClass) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        schoolClass.className,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList();
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppColors.primary,
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
                  icon: SFIcon(
                    SFIcons.sf_chevron_forward,
                  ),
                  openMenuIcon: SFIcon(
                    SFIcons.sf_chevron_down,
                  ),
                  iconSize: 16,
                  iconEnabledColor: AppColors.textSecondary,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppColors.background,
                  ),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStatePropertyAll<double>(6),
                    thumbVisibility: WidgetStatePropertyAll<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
          ),
          'value': getClassName(widget.pupil.classId),
        },
        {
          'title': 'Forældre',
          'showIcon': false,
          'isEditable': false,
          'cta': ctaButtons(() {}),
          'divider': false,
        },
      ];

  Widget ctaButtons(VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          selectedGuardian != null
              ? '${selectedGuardian!.firstName} ${selectedGuardian!.lastName}'
              : '${guardian.firstName} ${guardian.lastName}',
          style: AppTextStyles.bigText,
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: SFIcon(
            SFIcons.sf_chevron_right,
            color: AppColors.textPrimary,
            fontSize: 28,
          ),
          onPressed: () async {
            final selectedGuardianId = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                    builder: (context) => ChooseGuardian(
                          pupil: widget.pupil,
                          onPupilChanged: widget.onPupilChanged,
                        )));
            if (selectedGuardianId != null) {
              final selectedGuardian =
                  await PupilProfile.userService.fetchUser(selectedGuardianId);
              setState(() {
                if (selectedGuardianId == initialGuardianId) {
                  isEditingGuardians = false;
                  if (!isEditingFirstName &&
                      !isEditingLastName &&
                      !isEditingClass &&
                      !classChanges) {
                    hasChanges = false;
                  }
                  this.selectedGuardianId = selectedGuardianId;
                  this.selectedGuardian = selectedGuardian;
                  return;
                }
                this.selectedGuardianId = selectedGuardianId;
                this.selectedGuardian = selectedGuardian;
                onFieldChanged();
              });
            }
          },
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SettingsWidget(
              leftIcon: SFIcons.sf_figure_and_child_holdinghands,
              title: '${widget.pupil.firstName}s',
              subTitle:
                  'Her kan du redigere ${widget.pupil.firstName}s profil og klasse. ',
              type: SettingsType.header,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
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
                )),
              )
            ]),
          ),
          Spacer(),
          Visibility(
            visible: !hasChanges,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    text: 'Slet barn',
                    onTab: null,
                    backgroundColor: Colors.red,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 20)),
              ],
            ),
          ),
          Visibility(
            visible: hasChanges,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  CustomButton(
                    text: 'Gem ændringer',
                    onTab: () {
                      final navigator = Navigator.of(context); 
                      PupilProfile.childService
                          .updatePupil(
                              widget.pupil.pupilId,
                              updatedFirstName.isNotEmpty
                                  ? updatedFirstName
                                  : widget.pupil.firstName,
                              updatedLastName.isNotEmpty
                                  ? updatedLastName
                                  : widget.pupil.lastName,
                              selectedGuardianId ?? widget.pupil.guardianId,
                              int.parse(selectedClassId!))
                          .then((response) {

                        if (response.statusCode == 204) {  
                          navigator.pop();
                        } else {
                          throw Exception('Der skete en fejl');
                        }
                      });
                    },
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                  CustomButton(
                    text: 'Fortryd',
                    onTab: () => {
                      setState(() {
                        isEditingFirstName = false;
                        isEditingLastName = false;
                        isEditingClass = false;
                        classChanges = false;
                        hasChanges = false;
                        selectedClassId = initialClassId;
                        selectedGuardianId = initialGuardianId;
                        selectedGuardian = guardian;
                        firstNameController.text = widget.pupil.firstName;
                        lastNameController.text = widget.pupil.lastName;
                      }),
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
