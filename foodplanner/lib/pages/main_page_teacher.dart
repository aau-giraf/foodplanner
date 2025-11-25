import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/navigation/navbar_strategy_mapper.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/services/active_role_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

  //var activeRole = ActiveRoleService.activeRole;
  NavigationStrategy? navStrategy; 


  @override
  void initState() {
    super.initState();

    NavigationService.setCurrentPage(0);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadFromStorage().then((_) {
      authProvider.retrieveToken().then((token) {
        userService.fetchLoggedInUser().then((userData) {
          setState(() {
            _user = userData;
            navStrategy = NavBarStrategyMapper.getNavBarStrategy(userData.role);
            debugPrint('navStrategy $navStrategy');
            //debugPrint('_user ${_user.role}');
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
            'Velkommen \n${_user?.firstName}',
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
                  navStrategy?.goToPage(CHOOSE_CHILD_TEACHER, context);

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
                      'Vælg elev',
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
                navStrategy?.goToPage(SETTINGS_PAGE, context);
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

            /*
            if(activeRole == Role.teacher && _user.hasAllRoles([Role.admin, Role.teacher])) ...[
              SizedBox(height: 30),
              InkWell(
              hoverColor: Colors.transparent,
              onTap: () async {
                GoRouter.of(context).go(ADMIN_ROOT);
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
                      'Skift rolle',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center
                    ),
                    const Positioned(
                      right: 19,
                      child: Icon(
                        Icons.group,
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ],*/

            SizedBox(height: 30),
            InkWell(
              hoverColor: Colors.transparent,
              onTap: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                if(!context.mounted) {
                  return;
                }
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
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}

            