import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/child.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/child_service.dart';
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

class ParentProfile extends StatefulWidget {
  const ParentProfile({super.key});

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  static final ChildService childService =
      ChildService(apiUrl: ApiConfig.baseUrl);

  @override
  ParentProfileState createState() => ParentProfileState();
}

class ParentProfileState extends State<ParentProfile>
    with SingleTickerProviderStateMixin {
  User parent = User(
      id: 0,
      email: 'Unknown',
      firstName: 'Unknown',
      lastName: 'Unknown',
      role: 'Unknown',
      archived: false);

  Child child = Child(
      childId: 0,
      firstName: 'Unknown',
      lastName: 'Unknown',
      parentId: 0,
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

  @override
  void initState() {
    super.initState();
    fetchParentAndChild();
  }

  Future<void> fetchParentAndChild() async {
    final userInfo = await ParentProfile.userService.userInfo(parent.id);
    final fetchedChild = await ParentProfile.childService.fetchChildById();
    setState(() {
      parent = userInfo;
      child = fetchedChild;
      firstNameController.text = parent.firstName;
      lastNameController.text = parent.lastName;
      emailController.text = parent.email;
      updatedFirstName = parent.firstName;
      updatedLastName = parent.lastName;
      updatedEmail = parent.email;
    });
  }

  Future<void> updatePassword() async {
    final userInfo =
        await ParentProfile.userService.updatePassword(updatedPassword);
    setState(() {
      parent = userInfo;
      updatedPassword = passwordController.text;
    });
  }

  Future<void> updatePincode() async {
    final userInfo =
        await ParentProfile.userService.updatePincode(updatedPincode);
    setState(() {
      parent = userInfo;
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
      final response = await ParentProfile.userService.updateUser(
        parent.id,
        updatedFirstName.isNotEmpty ? updatedFirstName : parent.firstName,
        updatedLastName.isNotEmpty ? updatedLastName : parent.lastName,
        updatedEmail.isNotEmpty ? updatedEmail : parent.email,
      );
    }
  }

  Future<void> resetPage() async {
    await fetchParentAndChild();
    setState(() {
      isEditingFirstName = false;
      isEditingLastName = false;
      isEditingEmail = false;
      isEditingPassword = false;
      isEditingPincode = false;
      hasChanges = false;
    });
  }

  List<Map<String, dynamic>> get parentProfileItems => [
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
                              parent.firstName,
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
                              parent.lastName,
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
                              parent.email,
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
        {
          'title': 'Barn',
          'isEditable': false,
          'cta': Text('${child.firstName} ${child.lastName}'),
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
              title: '${parent.firstName} ${parent.lastName}',
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
                            ...parentProfileItems.map((item) {
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
                  Container(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Log ud',
                      onTab: () async {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.logout();
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
