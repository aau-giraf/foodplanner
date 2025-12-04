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

class AdminOneProfilePage extends StatefulWidget {
  const AdminOneProfilePage({super.key});
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  State<AdminOneProfilePage> createState() => _AdminOneProfilePageState();
}

class _AdminOneProfilePageState extends State<AdminOneProfilePage> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height:20),
            // Text: med navn og informationer om brugeren
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
                    Text('Navn navn anmoder om at blive accepteret'),
                  ],
                ),
              ),
            ),
            // Nuværende rolle: {UserRoles}
            // Tilknytning: {barn}
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
                    //if(UserRoles.fromString('Admin'))
                      Text('Fjern administatorrolle'),
                    //else if
                      // Text('Tildel administratorrolle'),
                  ],
                ),
              ),
            ),
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
            SettingsWidget(
              title: 'hej', 
              type: SettingsType.inlineItems,
              divider: false,
              clickable: true,
              ctaFunction: () async {
                Navigator.push(context, MaterialPageRoute(builder: (c) => AdminOneProfilePage()));
              },
            ),
            Card(
              color: Colors.white,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  
                },
                child: SettingsWidget(
                  title: 'Slet profil',
                  type: SettingsType.inlineItems,
                  divider: false,
                  cta: IconButton(
                    icon: const SFIcon(SFIcons.sf_trash),
                    onPressed: () {}, // valgfri
                  ),
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