import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/loading_animation.dart';
import 'package:foodplanner/components/right_icon_button.dart';
import 'package:foodplanner/components/popup_box.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/models/user_roles.dart';

class AdminOneProfilePage extends StatefulWidget {
  final User user;
  final bool isApproved;
  const AdminOneProfilePage({super.key, required this.user, required this.isApproved});

  @override
  State<AdminOneProfilePage> createState() => _AdminOneProfilePageState();
}

class _AdminOneProfilePageState extends State<AdminOneProfilePage> {

  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  // global variables for roles
  late final userRoles = widget.user.role;

  late final bool isPupil = userRoles.hasRole(Role.pupil);
  late final bool isGuardian = userRoles.hasRole(Role.guardian);
  late final bool isAdmin = userRoles.hasRole(Role.admin);
  late final bool isTeacher = userRoles.hasRole(Role.teacher); 

  List<GuardianUser>? guardiansOfPupil;

  bool _loadingGuardians = false;


  @override
  void initState() {
    super.initState();

    if(isPupil) {
      getGuardiansByPupil();
    }
  }

  void removeAdmin() {
    // add logic when corresponding endpoint has been created
  }

  void assignAdmin(){
    // add logic when corresponding endpoint has been created
  }

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

  Future<void> _deleteProfile() async {
    try {
      
      var response = await userService.deleteUser(widget.user.id);
      
      if (!mounted) return;

      if (response.statusCode == 204){
        _showSnackBar('Bruger er slettet', Colors.green);
        Navigator.of(context).pop(true);
      } else if (response.statusCode == 404) {
        _showSnackBar('Bruger forsøgt slettet kunne ikke findes.', AppColors.errorText);
      } else {
        _showSnackBar('Der opstod en ukent fejl under sletning af bruger', AppColors.errorText);
      }

    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Der opstod en ukent fejl under sletning af bruger', AppColors.errorText);
    }
  }

  Future<void> _acceptProfile() async {
    try {
      
      bool success = await userService.updateApproveUsers(widget.user.id);

      if (!mounted) return;

      if (success){
        _showSnackBar('Bruger er accepteret!', Colors.green);
        Navigator.of(context).pop(true);
      } else {
        _showSnackBar('Der opstod en ukent fejl under godkendelse af bruger', AppColors.errorText);
      } 

    } catch (e) {
      _showSnackBar('Der opstod en ukent fejl under godkendelse af bruger', AppColors.errorText);
    }
  }

  void _buildIphonePopupBox(String title, String action, Function onConfirm) {
    return showIPhonePopupBox(
      context: context,
      title: title,
      message: 'Er du sikker på, at du vil $action ${widget.user.firstName} ${widget.user.lastName}?',
      confirmText: 'Ja',
      cancelText: 'Nej',
      onConfirm: () async {
        Navigator.of(context).pop(); // closes the popup
        await onConfirm();
      },
      onCancel: (){
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildConfirmationIcons(VoidCallback onPressed, IconData sfIcon, String type) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.textFieldBorderFocus.withAlpha(70),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ], 
      ),
      child: IconButton(
        onPressed: onPressed, 
        icon: SFIcon(sfIcon, fontSize: 25),
        color: type == 'accept' ? Colors.green : type == 'deny' ? AppColors.errorText : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildConfirmationBox(){
    return Card(
      color: AppColors.background,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column( 
          children: [
            Text(
              '${widget.user.firstName} ${widget.user.lastName} anmoder om at blive accepteret',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Row (
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildConfirmationIcons(
                        () => _buildIphonePopupBox('Afvise Bruger', 'afvise anmodningen fra', _deleteProfile),
                        SFIcons.sf_multiply,
                        'deny',
                      ),
                      Spacer(),
                      _buildConfirmationIcons(
                        () => _buildIphonePopupBox('Accepter Bruger', 'acceptere anmodningen fra', _acceptProfile),
                        SFIcons.sf_checkmark,
                        'accept',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // OBS: There is not functionality for these buttons yet since there are no corresponding endpoints
  /*Widget _buildAdminRoleBtn() {
    return Card(
      elevation: 2,
      color: AppColors.background,
      child: GestureDetector(
        onTap:
          isAdmin ? removeAdmin :
          !isAdmin ? assignAdmin : 
          throw Exception('Fejl i at give en funktion'),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(10),
          child: isAdmin
          ? Text('Fjern administratorrolle')
          : !isAdmin
          ? Text('Tildel administratorrolle')
          : const SizedBox.shrink()
        ),
      ),
    );
  }*/

  Widget _buildInfoRow(String hintText, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(hintText, style: AppTextStyles.buttonTextMedium.copyWith(fontWeight: FontWeight.normal)),
        Text(info, style: AppTextStyles.buttonTextMedium.copyWith(fontWeight: FontWeight.normal)),
      ],
    );
  }

  Future<void> getGuardiansByPupil() async {
    setState(() {
      _loadingGuardians = true;
    });

    try {

      final fetchedGuardians = await userService.fetchAllGuardiansByPupilUserId(widget.user.id);

      setState(() {
        guardiansOfPupil = fetchedGuardians;
      });

    } finally {
      setState(() {
        _loadingGuardians = false;
      });
    }
  }

  bool _isLoading() {
    return _loadingGuardians; // futher add for fetching pupils of a guardian, etc
  }

  Widget _buildRelationRow() {
    if (isPupil){
      final guardiansNames = guardiansOfPupil!.map((guardian) => '${guardian.firstName} ${guardian.lastName}').join(',');

      if (guardiansNames.isEmpty){
        return _buildInfoRow('Tilknytning:', 'Ingen');
      }

      return _buildInfoRow('Tilknytning:', guardiansNames);
    } else if (isGuardian) {
      // add logic for fetching a parent's relations when the endpoint is created
      return _buildInfoRow('Tilknytning:', 'barn');
    }

    return const SizedBox.shrink();
  }
  
  // Ensures that the role shown in the text is intuitive
  String _parseRoleString(){
    if (isAdmin){
      return "Administrator";
    } else if (isTeacher){
      return "Lærer";
    } else if (isPupil){
      return "Elev";
    } else if (isGuardian){
      return "Forælder";
    }
    return "Ukendt rolle";
  }

  @override
  Widget build(BuildContext context) {
    // show loading animation if any info is still loaded 
    if(_isLoading()) {
      return const Center(
        child: LoadingAnimation(
          imagePath: 'assets/images/logo.png',
          size: 50.0, 
        )
      );
    }
    // build page if information is loaded
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 225,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ' Administrér \n profil',
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              Icon(
                Icons.manage_accounts_outlined,
                size: 30,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        // Popup med ting der skal fikses, fx: "Bob Olsen anmoder om tilknytning til Georg Olsen"
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!widget.isApproved) _buildConfirmationBox(),
            Text(
              '${widget.user.firstName} ${widget.user.lastName}',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            _buildInfoRow('Nuværende rolle:', _parseRoleString()),
            if (isGuardian || isPupil) _buildRelationRow(), //OBS: KAN KUN VISE FORÆLDRE FOR BARN SO FAR
            if (isAdmin || isTeacher) _buildInfoRow('Email:', widget.user.email), // could be relevant to show email for employees at the school 
            /*if (isTeacher) _buildAdminRoleBtn(),*/ // not relevant since there is no logic for it
            RightIconButton(
              alignment: MainAxisAlignment.spaceBetween,
              buttonText: 'Slet profil',
              sfIcon: SFIcon(
                SFIcons.sf_trash,
                fontSize: 16,
              ),
              onTab: () => _buildIphonePopupBox('Slet Bruger', 'slette brugeren for', _deleteProfile),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}