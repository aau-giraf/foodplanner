import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/choose_child_parent.dart';
import 'package:foodplanner/pages/login_page.dart';
import 'package:foodplanner/pages/settings/settings.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';
import 'package:foodplanner/config/colors.dart';

class TeacherMainPage extends StatefulWidget {
  const TeacherMainPage({super.key});

  @override
  State<TeacherMainPage> createState() =>
      TeacherMainPageState();
}

class TeacherMainPageState extends State<TeacherMainPage> {
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
        toolbarHeight: 200,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Text(
            'Velkommen \n${_user?.firstName ?? 'Lærer'}',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          )
        )
      ),
      backgroundColor: Colors.white,
      
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 181),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              hoverColor: Colors.transparent,
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => ChooseChildParent())  
                );
              },
              
              child: Container(
                height: 59,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow:[
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ]
                ),
                padding: const EdgeInsets.all(15),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Vælg barn',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center
                    ),
                    const Positioned(
                      right: 19,
                      child: Icon(
                        Icons.escalator_warning,
                      ),
                    ),
                  ]
                ),
              ),
            ),

            SizedBox(height: 30),
            InkWell(
              hoverColor: Colors.transparent,
              onTap: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => Settings())  
                );
              },
              child: Container(
                height: 59,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow:[
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ]
                ),
                padding: const EdgeInsets.all(15),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Indstillinger',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center
                    ),
                    const Positioned(
                      right: 19,
                      child: Icon(
                        Icons.settings,
                      ),
                    ),
                  ]
                ),
              ),
            ),

            SizedBox(height: 30),
            InkWell(
              hoverColor: Colors.transparent,
              onTap: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                context.go(LOGIN_PAGE);
              },
              child: Container(
                height: 59,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow:[
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ]
                ),
                padding: const EdgeInsets.all(15),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Text(
                      'Log ud',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center
                    ),
                    const Positioned(
                      right: 19,
                      child: Icon(
                        Icons.logout,
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}

            