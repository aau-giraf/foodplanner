import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:foodplanner/pages/settings/administrate_children.dart';
import 'package:foodplanner/pages/settings/admin_approve_page.dart';
import 'package:foodplanner/pages/settings/school_classes.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/pages/settings/deactivate_accounts.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/components/text_field.dart';

// næste der skal kigge den igennem, så har jeg fået inspiration fra: profile_page

class Settings extends StatefulWidget {
  const Settings({super.key});

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  static final ChildService childService =
      ChildService(apiUrl: ApiConfig.baseUrl);

  @override
  State<Settings> createState() => _SettingsPage();
}

class _SettingsPage extends State<Settings> with SingleTickerProviderStateMixin {
  User user = User(
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
      classId: 0);

  // DB:
  // child_relation:  user_id, child_id
  // users:           id, first_name, last_name, email, password, role, pincode, role_approced, archived
  // children:        child_id, first_name, last_name, class_id

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

  ROLES? userRole;

  @override
  void initState(){
    super.initState();

    AuthProvider().retrieveRole().then((role) {
      if(role == ROLES.teacher || role == ROLES.admin || role == ROLES.parent){
        fetchUser();
      } else {
        fetchUserToChild();
      }
      userRole = role;
    });
  }
  
  fetchUser(){
    final userInfo = await Settings.userService.fetchLoggedInUser();
    setState(() {
      user = userInfo;
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      updatedFirstName = user.firstName;
      updatedLastName = user.lastName;
      updatedEmail = user.email;
    });
  }

  fetchUserToChild(){
    final userInfo = await Settings.userService.userInfo(user.id);
    final fetchedChild = await Settings.childService.fetchChildById();
    setState(() {
      user = userInfo;
      child = fetchedChild;
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      updatedFirstName = user.firstname;
      updatedLastName = user.lastName;
      updatedEmail = user.email;
    });
  }

  Future<void> updatedPassword() async {
    final userInfo = await Settings.userService.updatePassword(updatedPassword);
    setState(() {
      user = userInfo;
      updatedPassword = passwordController.text;
    });
  }

  Future<void> updatePincode() async {
    final userInfo = await Settings.userService.updatePincode(updatedPincode);
    setState(() {
      user = userInfo;
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

  void onFieldChanged(){
    setState(() {
      hasChanges = true;
    });
  }

  Future<void> saveChanges() async {
    if(updatedFirstName.isNotEmpty ||
        updatedLastName.isNotEmpty ||
        updatedEmail.isNotEmpty){
          await Settings.userService.updateUser(
            user.id,
            updatedFirstName.isNotEmpty ? updatedFirstName : user.firstName,
            updatedLastName.isNotEmpty ? updatedLastName : user.lastName,
            updatedEmail.isNotEmpty ? updatedEmail : user.email,
          );
        }
  }

  // These things are notifications and biometric, and they do not have some functions yet
  //Set<String> selectedSegment = {'daily'};
  //bool notifications = true;
  //bool biometricLogin = true;
  //final showLunchBoxController = ValueNotifier<String>('daily');
  //final notificationsController = ValueNotifier<bool>(true);
  //final biometricLoginController = ValueNotifier<bool>(true);

  List<Map<String, dynamic>> get generalSettings => [
        {
          'title': "Fornavn:",
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
                          onChanged: (value){
                            updatedFirstName = value;
                            onFieldChanged();
                          }
                        )
                      )
                    )
                  : Row (
                    mainAxisAlignment:MainAxisAlignment.end,
                    children: [
                      Text(
                        user.firstName,
                        style: AppTextStyles.bigText,
                      )
                    ]
                  )
                ),
                IconButton(
                  icon: SFIcon(
                    SFIcons.sf_pencil,
                    color: AppColors.textPrimary,
                    fontSize: 28,
                  ),
                  onPressed: (){
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
          'title': "Efternavn:"
        },
        {
          'title': "Email:"
        },
        {
          'title': "Pin-kode:"
        },
        {
          'title': "Kodeord:"
        },
        /*{
          'title': "Vis madpakke",
          'icon': SFIcons.sf_fork_knife,
          'cta': AdvancedSegment(
              controller: showLunchBoxController,
              segments: {'daily': 'Dagligt', 'weekly': "Ugentligt"},
              activeStyle: AppTextStyles.standard.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              inactiveStyle: AppTextStyles.standardWithoutColor
                  .copyWith(fontWeight: FontWeight.bold),
              itemPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              sliderColor: AppColors.primary,
              sliderOffset: 0,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              backgroundColor: AppColors.lightSecondary),
        },*/
        /*{
          'title': "Notifikationer",
          'leftIcon': SFIcons.sf_bell_badge_fill,
          'cta': AdvancedSwitch(
            controller: notificationsController,
            activeColor: AppColors.primary,
            width: 60,
            initialValue: true,
          )
        },*/
        /*{
          'title': "Biometrisk login",
          'icon': SFIcons.sf_faceid,
          'cta': AdvancedSwitch(
            controller: biometricLoginController,
            activeColor: AppColors.primary,
            width: 60,
            initialValue: true,
          ),
          'divider': false,
        },*/
      ];
  List<Map<String, dynamic>> get adminSettings => [
        {
          'title': "Godkend profiler",
          'leftIcon': SFIcons.sf_person_crop_circle_badge_checkmark,
          'cta': Row(
            children: [
              (SFIcon(SFIcons.sf_chevron_forward)),
              SizedBox(width: 10),
            ],
          ),
          'ctaFunction': () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminApprovePage()),
            );
          }
        },
        {
          'title': "Deaktiver profiler",
          'leftIcon': SFIcons.sf_person_crop_circle_badge_minus,
          'cta': Row(
            children: [
              SFIcon(SFIcons.sf_chevron_forward),
              SizedBox(
                width: 10,
              )
            ],
          ),
          'ctaFunction': () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeactivateAccountsPage()),
            );
          }
        },
        {
          'title': "Administrer børn",
          'leftIcon': SFIcons.sf_figure_and_child_holdinghands,
          'cta': Row(
            children: [
              SFIcon(SFIcons.sf_chevron_forward),
              SizedBox(width: 10),
            ],
          ),
          'ctaFunction': () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdministrateChildren()),
            );
          }
        },
        {
          'title': "Administrer klasser",
          'leftIcon': SFIcons.sf_figure_2,
          'cta': Row(
            children: [
              SFIcon(SFIcons.sf_chevron_forward),
              SizedBox(width: 10),
            ],
          ),
          'divider': false,
          'ctaFunction': () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SchoolClasses()),
            );
          }
        },
      ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Indstillinger',
          style: AppTextStyles.headline2,
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: NavBar(currentPageIndex: 3),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
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
                        /*Text(
                          "Generelt",
                          style: AppTextStyles.bigText.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),*/
                        SizedBox(height: 10),
                        ...generalSettings.map((setting) {
                          return SettingsWidget(
                            leftIcon: setting['leftIcon'],
                            rightIcon : setting['rightIcon'],
                            title: setting['title'],
                            type: SettingsType.inlineItems,
                            cta: setting['cta'],
                            divider: setting['divider'] ?? true,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (authProvider.userRole?.hasRole(Role.admin) ?? false)
                Card(
                  elevation: 2,
                  color: AppColors.background,
                  surfaceTintColor: AppColors.background,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            "Admin",
                            style: AppTextStyles.bigText.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...adminSettings.map(
                            (setting) {
                              return SettingsWidget(
                                leftIcon: setting['leftIcon'],
                                rightIcon: setting['rightIcon'],
                                title: setting['title'],
                                type: SettingsType.inlineItems,
                                cta: setting['cta'],
                                divider: setting['divider'] ?? true,
                                clickable: true,
                                ctaFunction: setting['ctaFunction'],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomButton(
                  onTab: null,
                  text: "Log ud",
                  foregroundColor: AppColors.textFieldBorderFocus,
                  size: ButtonSize.medium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomButton(
                  onTab: null,
                  text: "Slet konto",
                  foregroundColor: AppColors.errorText,
                  backgroundColor: Colors.white,
                  size: ButtonSize.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
