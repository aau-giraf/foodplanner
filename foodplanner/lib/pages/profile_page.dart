import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/components/settings_header.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/components/button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/routes/paths.dart';

class GuardianProfile extends StatefulWidget {
  const GuardianProfile({super.key});

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  static final PupilService pupilService =
      PupilService(apiUrl: ApiConfig.baseUrl);

  @override
  GuardianProfileState createState() => GuardianProfileState();
}

class GuardianProfileState extends State<GuardianProfile>
    with SingleTickerProviderStateMixin {
  User guardian = User(
      id: 0,
      email: 'Unknown',
      firstName: 'Unknown',
      lastName: 'Unknown',
      role: UserRoles.empty(),
      archived: false);

  Pupil pupil = Pupil(
      pupilId: 0,
      firstName: 'Unknown',
      lastName: 'Unknown',
      guardianId: 0,
      classId: 0);

  bool isEditingFirstName = false;
  bool isEditingLastName = false;
  bool isEditingEmail = false;
  bool isEditingPassword = false;
  bool isEditingPincode = false;
  bool hasChanges = false;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  String updatedFirstName = '';
  String updatedLastName = '';
  String updatedEmail = '';
  String updatedPassword = '';
  String updatedPincode = '';

  UserRoles? userRole;

  @override
  void initState() {
    super.initState();

    AuthProvider().retrieveRole().then((role) {
      if ((role?.hasRole(Role.teacher) ?? false) || (role?.hasRole(Role.admin) ?? false)) {
        fetchAdminAndTeacher();
      } else {
        fetchGuardianAndPupil();
      }
      userRole = role;
    });
  }

  Future<void> fetchAdminAndTeacher() async {
    final userInfo = await GuardianProfile.userService.fetchLoggedInUser();
    setState(() {
      guardian = userInfo;
      firstNameController.text = guardian.firstName;
      lastNameController.text = guardian.lastName;
      emailController.text = guardian.email;
      updatedFirstName = guardian.firstName;
      updatedLastName = guardian.lastName;
      updatedEmail = guardian.email;
    });
  }

  Future<void> fetchGuardianAndPupil() async {
    final userInfo = await GuardianProfile.userService.userInfo(guardian.id);
    // A parent may have several children now; show the first one here.
    final fetchedPupils =
        await GuardianProfile.pupilService.fetchPupilsByParent();
    setState(() {
      guardian = userInfo;
      if (fetchedPupils.isNotEmpty) {
        pupil = fetchedPupils.first;
      }
      firstNameController.text = guardian.firstName;
      lastNameController.text = guardian.lastName;
      emailController.text = guardian.email;
      updatedFirstName = guardian.firstName;
      updatedLastName = guardian.lastName;
      updatedEmail = guardian.email;
    });
  }

  Future<void> updatePassword() async {
    final userInfo =
        await GuardianProfile.userService.updatePassword(updatedPassword);
    setState(() {
      guardian = userInfo;
      updatedPassword = passwordController.text;
    });
  }

  Future<void> updatePincode() async {
    final userInfo =
        await GuardianProfile.userService.updatePincode(updatedPincode);
    setState(() {
      guardian = userInfo;
      updatedPincode = pincodeController.text;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    pincodeController.dispose();

    super.dispose();
  }

  void onFieldChanged() {
    setState(() {
      hasChanges = true;
    });
  }

  Future<void> saveChanges() async {
    if (updatedFirstName.isNotEmpty ||
        updatedLastName.isNotEmpty ||
        updatedEmail.isNotEmpty) {
      await GuardianProfile.userService.updateUser(
        guardian.id,
        updatedFirstName.isNotEmpty ? updatedFirstName : guardian.firstName,
        updatedLastName.isNotEmpty ? updatedLastName : guardian.lastName,
        updatedEmail.isNotEmpty ? updatedEmail : guardian.email,
      );
    }
  }

  Future<void> resetPage() async {
    if ((userRole?.hasRole(Role.guardian) ?? false)) {
      await fetchGuardianAndPupil();
      setState(() {
        isEditingFirstName = false;
        isEditingLastName = false;
        isEditingEmail = false;
        isEditingPassword = false;
        isEditingPincode = false;
        hasChanges = false;
      });
    } else if ((userRole?.hasRole(Role.teacher) ?? false) || (userRole?.hasRole(Role.admin) ?? false)) {
      await fetchAdminAndTeacher();
      setState(() {
        isEditingFirstName = false;
        isEditingLastName = false;
        isEditingEmail = false;
        isEditingPassword = false;
        hasChanges = false;
      });
    }
  }

  List<Map<String, dynamic>> get guardianProfileItems => [
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
                          padding: const EdgeInsets.only(left: 17.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CustomTextField(
                              controller: firstNameController,
                              errorText: '',
                              hintText: 'Fornavn',
                              obscureText: false,
                              color: Colors.transparent,
                              onChanged: (value) {
                                updatedFirstName = value;
                                onFieldChanged();
                              },
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              guardian.firstName,
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
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CustomTextField(
                              controller: lastNameController,
                              errorText: '',
                              hintText: 'Efternavn',
                              obscureText: false,
                              color: Colors.transparent,
                              onChanged: (value) {
                                updatedLastName = value;
                                onFieldChanged();
                              },
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              guardian.lastName,
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
          'title': 'Email: ',
          'showIcon': false,
          'isEditable': isEditingEmail,
          'cta': Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: isEditingEmail
                      ? Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CustomTextField(
                              controller: emailController,
                              errorText: '',
                              hintText: 'Email',
                              obscureText: false,
                              color: Colors.transparent,
                              onChanged: (value) {
                                updatedEmail = value;
                                onFieldChanged();
                              },
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              guardian.email,
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
                      isEditingEmail = true;
                    });
                  },
                ),
              ],
            ),
          ),
          'showSpacer': false,
        },
        {
          'title': 'Password: ',
          'showIcon': false,
          'isEditable': isEditingPassword,
          'cta': Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: isEditingPassword
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CustomTextField(
                              controller: passwordController,
                              errorText: '',
                              hintText: 'Password',
                              obscureText: false,
                              color: Colors.transparent,
                              onChanged: (value) {
                                updatedPassword = value;
                                onFieldChanged();
                              },
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '********',
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
                      isEditingPassword = true;
                      passwordController.clear();
                    });
                  },
                ),
              ],
            ),
          ),
          'showSpacer': false,
        },
        {
          'title': 'Pincode: ',
          'showIcon': false,
          'isEditable': isEditingPincode,
          'cta': Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: isEditingPincode
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: CustomTextField(
                              controller: pincodeController,
                              errorText: '',
                              hintText: 'Pincode',
                              obscureText: false,
                              color: Colors.transparent,
                              onChanged: (value) {
                                updatedPincode = value;
                                onFieldChanged();
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4)
                              ],
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                              Text(
                                '****',
                                style: AppTextStyles.bigText,
                              ),
                            ]),
                ),
                IconButton(
                  icon: SFIcon(
                    SFIcons.sf_pencil,
                    color: AppColors.textPrimary,
                    fontSize: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      isEditingPincode = true;
                      pincodeController.clear();
                    });
                  },
                ),
              ],
            ),
          ),
          'showSpacer': false,
        },
        if (userRole?.hasRole(Role.guardian) ?? false)
          {
            'title': 'Barn',
            'isEditable': false,
            'cta': Text('${pupil.firstName} ${pupil.lastName}'),
            'divider': false,
          },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profil',
          style: AppTextStyles.headline4,
          textAlign: TextAlign.center,
        ),
      ),
      bottomNavigationBar: NavBar(currentPageIndex: 2),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsHeader(
              icon: SFIcons.sf_person_fill,
              title: '${guardian.firstName} ${guardian.lastName}',
              subtitle: 'Her kan du redigere dine oplysninger.',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            ...guardianProfileItems.map((item) {
                              return SettingsWidget(
                                title: item['title'],
                                isEditable: item['isEditable'],
                                cta: item['cta'],
                                type: SettingsType.inlineItems,
                                divider: item['divider'] ?? true,
                                showSpacer: item['showSpacer'] ?? true,
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: hasChanges,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        CustomButton(
                          text: 'Gem ændringer',
                          onTab: () {
                            saveChanges();
                            if (isEditingPassword) {
                              updatePassword();
                            }
                            if (isEditingPincode) {
                              updatePincode();
                            }
                            resetPage();
                          },
                        ),
                        SizedBox(height: 20),
                        CustomButton(
                          text: 'Fortryd',
                          onTab: () {
                            resetPage();
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Log ud',
                      onTab: () async {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.logout();
                        if (!context.mounted){
                          developer.log('buildcontext was unmounted in $runtimeType');
                          return;
                        }

                        context.go(LOGIN_PAGE);
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
