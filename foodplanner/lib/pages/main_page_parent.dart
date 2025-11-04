import 'package:flutter/material.dart';

import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/choose_child.dart';
import 'package:foodplanner/pages/login_page.dart';
import 'package:foodplanner/pages/settings/settings.dart';
import 'package:foodplanner/routes/paths.dart';



import 'package:foodplanner/services/api_config.dart';

import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class ParentMainPage extends StatefulWidget {
  const ParentMainPage({super.key});

  @override
  State<ParentMainPage> createState() =>
      ParentMainPageState();
}

class ParentMainPageState extends State<ParentMainPage> {
  final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  dynamic _user;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadFromStorage().then((_) {
      authProvider.retrieveToken().then((token) {
        userService.fetchLoggedInUser().then((userData) {
          setState(() {
            _user = userData;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            'Velkommen \n${_user?.firstName ?? 'Forældre'}',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          )
        )
      ),
      backgroundColor: Colors.white,
      
      
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ChooseChild())  
                );
              },
              child: Container(
                height: 59,
                width: 362,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12)
                ),
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Vælg barn',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )
              ),
            ),

            SizedBox(height: 30),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => Settings())  
                );
              },
              child: Container(
                height: 59,
                width: 362,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12)
                ),
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Indstillinger',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 30),
            InkWell(
              borderRadius: BorderRadius.circular(12),  
              /*onTab: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                context.go(LOGIN_PAGE);
              },*/
              child: Container(
                height: 59,
                width: 362,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12)
                ),
                padding: const EdgeInsets.all(15),
                child: Text(
                  'Log ud',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}

            