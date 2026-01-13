import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/pupil.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/components/text_field.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/routes/paths.dart';

class PupilSettings extends StatefulWidget {
  PupilSettings({super.key, required this.pupil});
  Pupil pupil;

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  static final PupilService pupilService = PupilService(apiUrl: ApiConfig.baseUrl);

  @override
  State<PupilSettings> createState() => _PupilSettingsPage();
}

class _PupilSettingsPage extends State<PupilSettings> with SingleTickerProviderStateMixin {
  String? oneTimePassword;
  
  // Why do we user User instead of Pupil?
  // User has a userId which we need to make changes to the Pupil in the database
  // we could probably still have used the Pupil class exclusively, would be a good refactor.
  late User user = User(
    id: widget.pupil.pupilId,
    email: 'Unknown',
    firstName: widget.pupil.firstName,
    lastName: widget.pupil.lastName,
    role: UserRoles.of({Role.pupil}),
    archived: false,
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
  
  Future<void> fetchUser() async {
    setState(() {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      emailController.text = user.email;
      updatedFirstName = user.firstName;
      updatedLastName = user.lastName;
      updatedEmail = user.email;
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
    await PupilSettings.pupilService.updatePupil(
      user.id,
      isEditingFirstName ? firstNameController.text.trim() : user.firstName,
      isEditingLastName ? lastNameController.text.trim() : user.lastName,
      widget.pupil.guardianId,
      widget.pupil.classId
    );

    user = User(
      id: user.id,
      firstName: isEditingFirstName ? firstNameController.text.trim() : user.firstName,
      lastName: isEditingLastName ? lastNameController.text.trim() : user.lastName,

      // unchangable in this widget, but required in the constructor.
      role: user.role,
      archived: user.archived,
      email: user.email
    );

    if(updatedFirstName.isNotEmpty ||
        updatedLastName.isNotEmpty ||
        updatedEmail.isNotEmpty){
          await PupilSettings.pupilService.updatePupil(
            user.id,
            updatedFirstName.isNotEmpty ? updatedFirstName : user.firstName,
            updatedLastName.isNotEmpty ? updatedLastName : user.lastName,
            widget.pupil.guardianId,
            widget.pupil.classId
          );

          widget.pupil = Pupil(
            pupilId: widget.pupil.pupilId, 
            firstName: updatedFirstName.isNotEmpty ? updatedFirstName : user.firstName,
            lastName: updatedLastName.isNotEmpty ? updatedLastName : user.lastName,
            classId: widget.pupil.classId
          );
        }
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
      
      var response = await PupilSettings.userService.deleteLoggedInUser();

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
                    onFieldChanged();
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
                          updatedLastName = value;
                          onFieldChanged();
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
                  },
                )
              ]
            )
          ),
          'showSpacer': false,
        },
        {
          'title': 'Engangskode: ',
          'showIcon': false,
          'isEditable': isEditingFirstName,
          'cta': Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(border: BoxBorder.symmetric()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                          child: Text(
                            oneTimePassword ?? "...",
                            style: AppTextStyles.bigText,
                          ),
                        ),
                        IconButton(
                          icon: SFIcon(
                            SFIcons.sf_document_on_clipboard_fill,
                            color: AppColors.textPrimary,
                            fontSize: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              if(oneTimePassword == null) {
                                return;
                              }
                              Clipboard.setData(ClipboardData(text: oneTimePassword!));
                            });
                          },
                        ),
                        IconButton(
                          icon: SFIcon(
                            SFIcons.sf_arrow_2_squarepath,
                            color: AppColors.textPrimary,
                            fontSize: 24,
                          ),
                          onPressed: () async {
                            PupilService pupilService = PupilService(apiUrl: ApiConfig.baseUrl);

                            var createdOneTimePassword = await pupilService.createOneTimePassword(widget.pupil.pupilId);
                            
                            setState(() {
                              oneTimePassword = createdOneTimePassword.body;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          'showSpacer': false,
        },
      ];

  void _handlePopWithSave() {

    Future.microtask(() =>
      Navigator.pop(context, widget.pupil)
    );
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // final messenger = ScaffoldMessenger.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, Pupil? result) {
        if(didPop) {
          return;
        }
        _handlePopWithSave();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: _handlePopWithSave, icon: Icon(Icons.arrow_back)),
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          centerTitle: true,
          title:              FittedBox(
            child: Text(
              'Indstillinger for ${updatedFirstName.isNotEmpty ? updatedFirstName : "${widget.pupil.firstName}"}',
              softWrap: true,
              style: TextStyle(fontSize: 36),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        bottomNavigationBar: NavBar(currentPageIndex: 0,),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(
                  Icons.settings_outlined,
                  color: AppColors.textPrimary,
                  size: 32.0,
                  semanticLabel: 'Settings',
                ),
                SizedBox(height: 20,),
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
                              text: 'Gem ændring',
                              onTab: () async {
                                await saveChanges();
                                await resetPage();
                                setState(() {
      
                                });
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
