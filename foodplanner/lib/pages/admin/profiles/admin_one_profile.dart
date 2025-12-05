import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/components/popup_box.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/models/user_roles.dart';

class AdminOneProfilePage extends StatefulWidget {
  final User user;
  const AdminOneProfilePage({super.key, required this.user});
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  State<AdminOneProfilePage> createState() => _AdminOneProfilePageState();
}

class _AdminOneProfilePageState extends State<AdminOneProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  removeAdmin(){
    print('Fjern admin');
  }

  giveAdmin(){
    print('Give admin');
  }

  deleteProfile(){
    print('Nu sletter du profilen');
  }

  Widget _checkRole(){
    final roles = widget.user.role.toString().split(',');

    final isAdmin = roles.contains('admin');
    final isTeacher = roles.contains('teacher');

    return Card(
      elevation: 2,
      color: AppColors.background,
      child: GestureDetector(
        onTap:
          isAdmin ? removeAdmin() :
          isTeacher && !isAdmin ? giveAdmin : throw Exception('Fejl i at give en funktion'),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(10),
          child: isAdmin
          ? Text('Fjern administratorrolle')
          : isTeacher && !isAdmin
          ? Text('Tildel administratorrolle')
          : const SizedBox.shrink()
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final roles = widget.user.role.toString().split(',');
    final isAdmin = roles.contains('admin');
    final isTeacher = roles.contains('teacher');

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
                'Administrér',
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              Text(
                'profil',
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              Icon(
                Icons.manage_accounts_outlined,
              ),
              SizedBox(height: 35),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              color: AppColors.background,
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text('Navn navn anmoder om at blive accepteret'),
                    Text('Navn navn anmoder om at blive accepteret'),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () { },
                      child: SFIcon(
                        SFIcons.sf_multiply,
                        fontSize: 16,
                      ),
                      //Text('TextButton'),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () { },
                      child: SFIcon(
                        SFIcons.sf_checkmark,
                        fontSize: 16,
                      ),
                      //Text('TextButton'),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fulde navn:'),
                Text('${widget.user.firstName} ${widget.user.lastName}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Email:'),
                Text('${widget.user.email}'),
              ],
            ),
            // Text('Accepteret: ${widget.user.approved}'),
            // Tjek parent, show this
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nuværende rolle:'),
                Text('${roles}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tilknytning:'),
                Text('barn'),
              ],
            ),
            // Indsætter et tomt felt, og ved ikke hvordan man kan fjerne det
            isAdmin || isTeacher ? _checkRole() : const SizedBox.shrink(),
            Card(
              elevation: 2,
              color: AppColors.background,
              child: GestureDetector(
                onTap: deleteProfile(),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text(
                        'Slet profil',
                        textAlign: TextAlign.center,
                      ),
                      Positioned(
                        right: 0,
                        child: SFIcon(
                            SFIcons.sf_trash,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                )
              )
            )
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}