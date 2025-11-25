import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/meal_box.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/child.dart';

import 'package:foodplanner/pages/pin_code.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChildLandingPageMadpakke extends StatefulWidget {
  final Map<String, String> student;
  
  const ChildLandingPageMadpakke(
      {super.key,
       /* required Map<String, String> */ 
       required this.student}
  );

  @override
  State<ChildLandingPageMadpakke> createState() =>
      _ChildLandingPageMadpakkeState();
}

class _ChildLandingPageMadpakkeState extends State<ChildLandingPageMadpakke> {
  late Future<bool> _hasRolesFuture;
  Child? _child;
  final ChildService childService = ChildService(apiUrl: ApiConfig.baseUrl);
  final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  UserRoles? userRole;
  Future<void>? _callerFuture;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final role = await authProvider.retrieveRole();
    debugPrint('Brugerrolle: $role');

    setState(() {
      userRole = role;
      _hasRolesFuture = authProvider.hasOneOfRoles([Role.parent, Role.student, Role.teacher]);
    });

    Child? childData;

    //baseret på userRole henter den barnets data ud fra personens egen profil eller fra den map man sendte ind via widgetten.
    if (authProvider.userRole == Role.student ||
        authProvider.userRole == Role.parent) {
      
      debugPrint('childData = $childData');
      try {
        final childData = await childService.fetchChildById();
        //final loggedInUser = await userService.fetchLoggedInUser();
        //debugPrint('Fetch resultat: $loggedInUser');
      } catch (e) {
        debugPrint('Fejl ved fetchChildById: $e');
      }
      
      setState(() {
        _child = childData;
      });
    } else if (authProvider.userRole == Role.teacher) {
      int tempChildId = int.parse(widget.student['id']!);
      childData = await childService.GetByChildId(tempChildId);
      
      /*setState(() {
        _child = childData;
      });*/
    }

    if(childData == null){
      debugPrint('childData er NULL - barn blev IKKE hentet!');
      setState(() {
        _child = childData;
        _callerFuture = caller();
      });
    }
    if(_child != null) {
      debugPrint('Barn fundet! kalder caller()');
      setState(() {
        _child = childData;
        _callerFuture = caller();
      });
    } else {
      debugPrint('Fejl: _child er fortsat null - _callerFuture bliver ikke sat!');
    }
  }


  Future<void> caller() async {
    /*if(_child?.parentId != null) {
      await MealNotifier().teacherUpdateChildId(_child!.parentId);
    }*/
    await MealNotifier().updateDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: userRole == Role.teacher || userRole == Role.admin
            ? IconButton(
                onPressed: () {
                  GoRouter.of(context).go(TEACHER_ROOT);
                },
                icon: Icon(SFIcons.sf_chevron_backward),
              )
            : null,
        title: Text(
          '${_child?.firstName} ${_child?.lastName}',
          style: AppTextStyles.headline4,
        ),
        centerTitle: true,
        actions: userRole != Role.teacher && userRole != Role.admin
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PinCode()),
                    );
                  },
                  icon: SFIcon(SFIcons.sf_lock_fill),
                ),
              ]
            : null,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FutureBuilder(
                      future: _callerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          
                          if(_child == null){
                            return Text('Data for barnet kunne ikke hentes');
                          }

                          return ReusableMealBox();
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ), // Use the reusable widget
                  SizedBox(height: 20),
                  if ((userRole?.hasRole(Role.teacher) ?? false) || (userRole?.hasRole(Role.admin) ?? false))
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                        onTab: () {
                          GoRouter.of(context).go(
                            FEEDBACK_Page,
                            extra: {
                              'from': TEACHER_ROOT,
                              'childId': _child!.childId.toString()
                            },
                          );
                        },
                        text: 'Giv Feedback',
                        //fontSize: 16,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
