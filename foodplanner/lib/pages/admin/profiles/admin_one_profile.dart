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
    print('Nu er du herher');
  }

  giveAdmin(){
    print('Nu er du her');
  }

  Widget _checkRole(){
    final roles = widget.user.role.toString().split(',');

    final isAdmin = roles.contains('admin');
    final isTeacher = roles.contains('teacher');

    if (isAdmin) {
      return GestureDetector(
        onTap: removeAdmin,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          child: Text(
            'Fjern administrator',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ),
      );
    }

    if (isTeacher && !isAdmin) {
      return GestureDetector(
        onTap: giveAdmin,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          child: Text(
            'Tildel administrator',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
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
              color: Colors.grey,
              elevation: 2,
              child: Column(
                children: [
                  ColoredBox(
                    color: Colors.blue,
                  ),
                  Text('Navn navn anmoder om at blive accepteret'),
                ],
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
            isAdmin || isTeacher ? _checkRole() : SizedBox(width: 0, height: 0),
            
            Card(
              color: Colors.grey,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ColoredBox(
                      color: Colors.blue,
                    ),
                    Text('Slet profil'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}