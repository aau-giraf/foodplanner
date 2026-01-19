import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/custom_app_bar.dart';
import 'package:foodplanner/components/editable_settings_tile.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/components/popup_box.dart';
import 'package:foodplanner/config/colors.dart';

import 'package:foodplanner/models/settings_data.dart';
import 'package:foodplanner/models/user.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart' show UserService;

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  late User currentUser;
  late SettingsData editedData;
  int numberOfEdits = 0;
  List<User> totalAdminUsers = [];

  int edits = 0;

  @override
  void initState(){
    super.initState();
    currentUser = User(
      id: 0,
      email: 'Unknown',
      firstName: 'Unknown',
      lastName: 'Unknown',
      role: UserRoles.empty(),
      archived: false, 
    );
    editedData = SettingsData.fromUser(currentUser);
    _fetchUserInfo();
  }

  bool get hasChanges => numberOfEdits > 0;

  bool get isFirstNameEdited => editedData.firstName.trim() != currentUser.firstName.trim();
  bool get isLastNameEdited => editedData.lastName.trim() != currentUser.lastName.trim();
  bool get isEmailEdited => editedData.email.trim() != currentUser.email.trim();
  bool get isPasswordEdited => editedData.password.isNotEmpty;
  bool get isPincodeEdited => editedData.pincode.isNotEmpty;
  bool get isAdmin => currentUser.role.hasRole(Role.admin);

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _showSnackBar(String text, Color color){
    final messenger = ScaffoldMessenger.of(context);
    return messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        duration: Duration(seconds: 5),
      ),
    );
  }

  void calculateNumberOfEdits() {
    setState(() {
      numberOfEdits = 0;
      if (isFirstNameEdited) numberOfEdits++;
      if (isLastNameEdited) numberOfEdits++;
      if (isEmailEdited) numberOfEdits++;
      if (isPasswordEdited) numberOfEdits++;
      if (isPincodeEdited) numberOfEdits++;
    });
  }

  // Helper methods for updating daata
  void updateFirstName(String value) {
    editedData.firstName = value;
    calculateNumberOfEdits();
  }

  void updateLastName(String value) {
    editedData.lastName = value;
    calculateNumberOfEdits();
  }

  void updateEmail(String value) {
    editedData.email = value;
    calculateNumberOfEdits();
  }

  void updatePassword(String value) {
    editedData.password = value;
    calculateNumberOfEdits();
  }

  void updatePincode(String value) {
    editedData.pincode = value;
    calculateNumberOfEdits();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userInfo = await userService.fetchLoggedInUser();
      setState((){
        currentUser = userInfo;
        editedData = SettingsData.fromUser(userInfo);
        calculateNumberOfEdits();
      });
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> saveChanges() async {
    try {
      await userService.updateUser(
        currentUser.id, 
        isFirstNameEdited ? editedData.firstName : currentUser.firstName, 
        isLastNameEdited ? editedData.lastName : currentUser.lastName, 
        isEmailEdited ? editedData.email : currentUser.email,
      );

      if (isPincodeEdited) {
        await userService.updatePincode(editedData.pincode);
      }

      if (isPasswordEdited) {
        await userService.updatePassword(editedData.password);
      }

      resetPage();

    } catch (e) {
      _showSnackBar('Fejl under gemning. Prøv igen', AppColors.errorText);
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
    await _fetchUserInfo();
    setState(() {
      editedData.password = '';
      editedData.pincode = '';
      numberOfEdits = 0;
    });
  }

  void discardChanges() {
    setState(() {
      editedData.firstName = currentUser.firstName;
      editedData.lastName = currentUser.lastName;
      editedData.email = currentUser.email;
      editedData.password = '';
      editedData.pincode = '';
      numberOfEdits = 0;
    });
  }

  Future<List<User>> findAdminUsers() async {
    totalAdminUsers.clear();
    var allUsers = await userService.fetchAllUsers();
    for (var user in allUsers){
      if (user.role.hasRole(Role.admin)){
        totalAdminUsers.add(user);
      }
    }
    return totalAdminUsers;
  }

  void deleteLoggedInUser() async {
    try {
      
      var response = await userService.deleteLoggedInUser();

      if (response.statusCode == 204){
        _showSnackBar('Bruger er slettet', Colors.green);
        context.go(LOGIN_PAGE);
      } else if (response.statusCode == 404) {
        _showSnackBar('Bruger forsøgt slettet kunne ikke findes.', AppColors.errorText);
      } else {
        _showSnackBar('Der opstod en ukendt fejl under sletning af bruger', AppColors.errorText);
      }

    } catch (e) {
      _showSnackBar('Der opstod en ukendt fejl under sletning af bruger', AppColors.errorText);
    }
  }

  Future<bool> canDeleteAdminUser() async {
    List<User> totalAdminUsers = await findAdminUsers();
    return totalAdminUsers.length < 2 ? false : true;
  }

  void _showDeletionPopUp(){
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

  void _showAdminRestrictionPopup(BuildContext context) async {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Du kan ikke slette din bruger'),
        content: const Text('For at slette din konto skal du først tildele admin rollen til en anden lærer'),
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
  }

  void showAdminPopup(BuildContext context) async {
    if (await canDeleteAdminUser()){
      _showDeletionPopUp();
    } else {
      _showAdminRestrictionPopup(context);
    }
  }

  void _handleDeletion(BuildContext context) async {
    if (isAdmin) {
      showAdminPopup(context);
    } else {
      _showDeletionPopUp();
    }
  }

  Widget _buildSaveButton(){
    return Column(
      children: [
        SizedBox(height: 20),
        CustomButton(
          text: numberOfEdits > 1 ? 'Gem ændringer' : 'Gem ændring',
          onTab: saveChanges,
        ),
        SizedBox(height: 20),
        CustomButton(
          text: numberOfEdits > 1 ? 'Annuller ændringer' : 'Annuller ændring',
          onTab: discardChanges,
          backgroundColor: AppColors.background,
          foregroundColor: Colors.black,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildEditableFields(User user, SettingsData data){
    return Column(
      children: [
        SizedBox(height: 10),
        EditableSettingsTile(
          title: 'Fornavn', 
          initialValue: '', 
          isEdited: isFirstNameEdited, 
          onChanged: updateFirstName,
          hintText: user.firstName,
          obscure: false,
        ),
        EditableSettingsTile(
          title: 'Efternavn', 
          initialValue: '', 
          isEdited: isLastNameEdited, 
          onChanged: updateLastName,
          hintText: user.lastName,
          obscure: false,
        ),
        EditableSettingsTile(
          title: 'Email', 
          initialValue: '', 
          isEdited: isEmailEdited, 
          onChanged: updateEmail,
          hintText: user.email,
          obscure: false,
        ),
        EditableSettingsTile(
          title: 'Kodeord', 
          initialValue: '', 
          isEdited: isPasswordEdited, 
          onChanged: updatePassword,
          hintText: '********',
          obscure: true,
        ),
        EditableSettingsTile(
          title: 'Pin-kode', 
          initialValue: data.pincode, 
          isEdited: isPincodeEdited, 
          onChanged: updatePincode,
          hintText: '****',
          obscure: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    final data = editedData;

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Indstillinger', 
        materialIcon: Icon(
          Icons.settings_outlined,
           color: AppColors.textPrimary,
            size: 32.0,
            semanticLabel: 'Settings',
        ),
        screenHeight: screenHeight,
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
                          child: _buildEditableFields(user, data),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: numberOfEdits > 0,
                      child: _buildSaveButton(),
                    ),
                  ],
                ),
              ),
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
                  onTab: () => _handleDeletion(context),
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