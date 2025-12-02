import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/components/popup_box.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/routes/paths.dart';
import 'dart:developer' as developer;

class Settings extends StatefulWidget {
  const Settings({super.key});

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  State<Settings> createState() => _SettingsPage();
}

class _SettingsPage extends State<Settings> with SingleTickerProviderStateMixin {

  User user = User(
    id: 0,
    email: 'Unknown',
    firstName: 'Unknown',
    lastName: 'Unknown',
    role: UserRoles.empty(),
    archived: false
  );

  IconData? icon;
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

  List<User> totalAdminUsers = [];
  int edits = 0;

  @override
  void initState(){
    super.initState();

    AuthProvider().retrieveRole().then((role) {
      fetchUser();
      print(role);
      userRole = role;
    });
  }
  
  Future<void> fetchUser() async {
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

  Future<void> updatePassword() async {
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
    await Settings.userService.updateUser(
      user.id,
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      emailController.text.trim()
    );

    final futures = <Future<void>>[];

    if(isEditingPassword && updatedPassword.trim().isNotEmpty) {
      futures.add(updatePassword());
    }

    if(isEditingPincode && updatedPincode.trim().isNotEmpty){
      futures.add(updatePincode());
    }

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

  void showDeletionPopUp(){
    showIPhonePopupBox(
      context: context,
      title: 'Slet bruger',
      message: 'Er du sikker på, at du vil slette din konto?',
      confirmText: 'Ja',
      cancelText: 'Nej',
      onConfirm: (){
        deleteLoggedInUser();
      },
      onCancel: (){
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> resetPage() async {
    await fetchUser();
    setState(() {
      isEditingFirstName = false;
      isEditingLastName = false;
      isEditingEmail = false;
      isEditingPassword = false;
      isEditingPincode = false;
      hasChanges = false;
    });
  }


  void deleteLoggedInUser() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      
      var response = await Settings.userService.deleteLoggedInUser();

      if (response.statusCode == 204){
        messenger.showSnackBar( 
          SnackBar(
            content: Text('Bruger er slettet.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
        context.go(LOGIN_PAGE);
      } else if (response.statusCode == 404) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Bruger forsøgt slettet kunne ikke findes.'),
            backgroundColor: AppColors.errorText,
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Der opstod en ukendt fejl under sletning af bruger.'),
            backgroundColor: AppColors.errorText,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(
            content: Text('Der opstod en ukendt fejl under sletning af bruger: $e.'),
            backgroundColor: AppColors.errorText,
            duration: Duration(seconds: 5),
          ),
        );
    }
  }

    Future<List<User>> findOtherAdminUsers() async {
    var allUsers = await Settings.userService.fetchAllUsers();
    print(allUsers);
    for (var user in allUsers){
      if (user.role.hasRole(Role.admin)){
        totalAdminUsers.add(user);
        print(totalAdminUsers.length);
      }
    }
    return totalAdminUsers;
  }

  void deleteLoggedInAdminUser() async {
    List<User> totalAdminUsers = await findOtherAdminUsers();
    if (totalAdminUsers.length < 2){
      showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Du kan ikke slette din bruger'),
        content: const Text('For at slette din konto skal du først tildele adminrollen til en anden lærer'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          ),
        ],
      ),
      );
    } else {
      showDeletionPopUp();
    }
  }

  int numberOfEdits(){
    return edits;
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
                            edits++;
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
                    onFieldChanged();
                    edits++;
                  },
                ),
              ],
            ),
          ),
          'showSpacer': false,
        },
        {
          'title': "Efternavn:",
          'showIcon': false,
          'isEditable': isEditingLastName,
          'cta': Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: isEditingLastName ? Padding(
                    padding: const EdgeInsets.only(left:10.0),
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
                        onChanged: (value){
                          isEditingLastName = true;
                          updatedLastName = value;
                          onFieldChanged();
                          edits++;
                        },
                      )
                    )
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        user.lastName,
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
                      isEditingLastName = true;
                    });
                    onFieldChanged();
                    edits++;
                  },
                )
              ]
            )
          ),
          'showSpacer': false,
        },
        {
          'title': "Email:",
          'showIcon': false,
          'isEditable': isEditingEmail,
          'cta': Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: isEditingEmail ? Padding(
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
                          edits++;
                        },
                      )
                    )
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        user.email,
                        style:AppTextStyles.bigText,
                      )
                    ],
                  )
                ),
                IconButton(
                  icon: SFIcon (
                    SFIcons.sf_pencil,
                    color: AppColors.textPrimary,
                    fontSize: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      isEditingEmail = true;
                    });
                    onFieldChanged();
                    edits++;
                  },
                )
              ],
            )
          ),
          'showSpacer': false,
        },
        {
          'title': "Kodeord:",
          'showIcon': false,
          'isEditable': isEditingPassword,
          'cta': Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: isEditingPassword ? Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: CustomTextField(
                        controller: passwordController,
                        errorText: '',
                        hintText: 'Adgangskode',
                        obscureText: false,
                        color: Colors.transparent,
                        onChanged: (value) {
                          updatedPassword = value;
                          onFieldChanged();
                          edits++;
                        }
                      )
                    )
                  )
                  : Row (
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '********',
                        style: AppTextStyles.bigText,
                      )
                    ],
                  )
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
                    onFieldChanged();
                    edits++;
                  },
                )
              ]
            )
          ),
          'showSpacer': false,
        },
        {
          'title': "Pin-kode:",
          'showIcon': false,
          'isEditable': isEditingPincode,
          'cta': Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: isEditingPincode ? Padding(
                    padding: const EdgeInsets.only(left: 17.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: CustomTextField(
                        controller: pincodeController,
                        errorText: '',
                        hintText: 'Pinkode',
                        obscureText: false,
                        color: Colors.transparent,
                        onChanged: (value) {
                          updatedPincode = value;
                          onFieldChanged();
                          edits++;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4)
                        ],
                      )
                    )
                  )
                  : Row (
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '****',
                        style: AppTextStyles.bigText,
                      )
                    ]
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
                      isEditingPincode = true;
                      pincodeController.clear();
                    });
                    onFieldChanged();
                    edits++;
                  },
                )
              ]
            )
          ),
          'divider': false,
          'showSpacer': false,
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

  // Det her skal ikke være herinde mere, men sletter ikke lige, i tilfælde af vi vil bruge det
  /*List<Map<String, dynamic>> get adminSettings => [
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
              MaterialPageRoute(builder: (context) => AdministratePupils()),
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
      ];*/

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final messenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 200,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 25),
          /*child: Text(
            'Indstillinger',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          ),*/
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Indstillinger',
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Icon(
                Icons.settings_outlined,
                color: AppColors.textPrimary,
                size: 32.0,
                semanticLabel: 'Settings',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
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
                              ...generalSettings.map((setting) {
                                return SettingsWidget(
                                  leftIcon: setting['leftIcon'],
                                  title: setting['title'],
                                  isEditable: setting['isEditable'],
                                  cta: setting['cta'],
                                  type: SettingsType.inlineItems,
                                  divider: setting['divider'] ?? true,
                                  showSpacer: setting['showSpacer'] ?? true,
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
                            text: edits > 1 ? 'Gem ændringer' : 'Gem ændring',
                            onTab: () async {
                              await saveChanges();
                              await resetPage();
                            },
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            text: 'Fortryd',
                            onTab: () {
                              resetPage();
                            },
                            backgroundColor: AppColors.background,
                            foregroundColor: Colors.black,
                          )
                        ]
                      )
                    ),
                  ]
                )
              ),
              SizedBox(height: 10),
              // Da der ikke er forskel på settings med de forskellige user roles, så skal dette også væk
              /*if (authProvider.hasRole([ROLES.admin]))
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
                ),*/
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomButton(
                  text: "Log ud",
                  onTab: () async {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    await authProvider.logout();
                    if (!context.mounted){
                      print('buildcontext was unmounted in $runtimeType');
                      return;
                    }
                    GoRouter.of(context).go(LOGIN_PAGE);
                  },
                  foregroundColor: AppColors.textFieldBorderFocus,
                  backgroundColor: AppColors.background,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomButton(
                  text: "Slet konto",
                  onTab: () {
                    if(user.role.hasRole(Role.admin)){
                      deleteLoggedInAdminUser();
                    } else {
                    showDeletionPopUp();
                    }
                  },
                  foregroundColor: AppColors.errorText,
                  backgroundColor: AppColors.background,
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
