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
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final UserService _userService = UserService(apiUrl: ApiConfig.baseUrl);
  late User _currentUser;
  late SettingsData _editedData;
  int _numberOfEdits = 0;
  List<User> totalAdminUsers = [];

  List<User> totalAdminUsers = [];
  int edits = 0;

  @override
  void initState(){
    super.initState();
    _currentUser = User(
      id: 0,
      email: 'Unknown',
      firstName: 'Unknown',
      lastName: 'Unknown',
      role: UserRoles.empty(),
      archived: false, 
    );
    _editedData = SettingsData.fromUser(_currentUser);
    _fetchUserInfo();
  }

  bool get hasChanges => _numberOfEdits > 0;

  bool get isFirstNameEdited => _editedData.firstName.trim() != _currentUser.firstName.trim();
  bool get isLastNameEdited => _editedData.lastName.trim() != _currentUser.lastName.trim();
  bool get isEmailEdited => _editedData.email.trim() != _currentUser.email.trim();
  bool get isPasswordEdited => _editedData.password.isNotEmpty;
  bool get isPincodeEdited => _editedData.pincode.isNotEmpty;
  bool get isAdmin => _currentUser.role.hasRole(Role.admin);

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

  void _calculateNumberOfEdits() {
    setState(() {
      _numberOfEdits = 0;
      if (isFirstNameEdited) _numberOfEdits++;
      if (isLastNameEdited) _numberOfEdits++;
      if (isEmailEdited) _numberOfEdits++;
      if (isPasswordEdited) _numberOfEdits++;
      if (isPincodeEdited) _numberOfEdits++;
    });
  }

  // Helper methods for updating daata
  void updateFirstName(String value) {
    _editedData.firstName = value;
    _calculateNumberOfEdits();
  }

  void updateLastName(String value) {
    _editedData.lastName = value;
    _calculateNumberOfEdits();
  }

  void updateEmail(String value) {
    _editedData.email = value;
    _calculateNumberOfEdits();
  }

  void updatePassword(String value) {
    _editedData.password = value;
    _calculateNumberOfEdits();
  }

  void updatePincode(String value) {
    _editedData.pincode = value;
    _calculateNumberOfEdits();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final userInfo = await _userService.fetchLoggedInUser();
      setState((){
        _currentUser = userInfo;
        _editedData = SettingsData.fromUser(userInfo);
        _calculateNumberOfEdits();
      });
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> saveChanges() async {
    try {
      await _userService.updateUser(
        _currentUser.id, 
        isFirstNameEdited ? _editedData.firstName : _currentUser.firstName, 
        isLastNameEdited ? _editedData.lastName : _currentUser.lastName, 
        isEmailEdited ? _editedData.email : _currentUser.email,
      );

      if (isPincodeEdited) {
        await _userService.updatePincode(_editedData.pincode);
      }

      if (isPasswordEdited) {
        await _userService.updatePassword(_editedData.password);
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
      _editedData.password = '';
      _editedData.pincode = '';
      _numberOfEdits = 0;
    });
  }

  void discardChanges() {
    setState(() {
      _editedData.firstName = _currentUser.firstName;
      _editedData.lastName = _currentUser.lastName;
      _editedData.email = _currentUser.email;
      _editedData.password = '';
      _editedData.pincode = '';
      _numberOfEdits = 0;
    });
  }

  Future<List<User>> findAdminUsers() async {
    totalAdminUsers.clear();
    var allUsers = await _userService.fetchAllUsers();
    for (var user in allUsers){
      if (user.role.hasRole(Role.admin)){
        totalAdminUsers.add(user);
      }
    }
    return totalAdminUsers;
  }

  void deleteLoggedInUser() async {
    try {
      
      var response = await _userService.deleteLoggedInUser();

      if (response.statusCode == 204){
        _showSnackBar('Bruger er slettet', Colors.green);
        context.go(LOGIN_PAGE);
      } else if (response.statusCode == 404) {
        _showSnackBar('Bruger forsøgt slettet kunne ikke findes.', AppColors.errorText);
      } else {
        _showSnackBar('Der opstod en ukent fejl under sletning af bruger', AppColors.errorText);
      }

    } catch (e) {
      _showSnackBar('Der opstod en ukent fejl under sletning af bruger', AppColors.errorText);
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
          text: _numberOfEdits > 1 ? 'Gem ændringer' : 'Gem ændring',
          onTab: saveChanges,
        ),
        SizedBox(height: 20),
        CustomButton(
          text: 'Fortryd',
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
    final user = _currentUser;
    final data = _editedData;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Indstillinger', 
        materialIcon: Icon(
          Icons.settings_outlined,
           color: AppColors.textPrimary,
            size: 32.0,
            semanticLabel: 'Settings',
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
                          child: _buildEditableFields(user, data),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _numberOfEdits > 0,
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