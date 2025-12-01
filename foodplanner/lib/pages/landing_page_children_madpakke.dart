import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/api/openapi/lib/api.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/meal_box.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/pupil.dart';

import 'package:foodplanner/pages/pin_code.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/pupil_service.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PupilLandingPageMadpakke extends StatefulWidget {
  final Map<String, String> pupil;
  const PupilLandingPageMadpakke(
      {super.key, /* required Map<String, String> */ required this.pupil});

  @override
  State<PupilLandingPageMadpakke> createState() =>
      _PupilLandingPageMadpakkeState();
}

class _PupilLandingPageMadpakkeState extends State<PupilLandingPageMadpakke> {
  //ignore: unused_field 
  late Future<bool> _hasRolesFuture;
  Pupil? _pupil;
  final PupilService pupilService = PupilService(apiUrl: ApiConfig.baseUrl);
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
    //debugPrint('Brugerrolle: $role');

    setState(() {
      userRole = role;
      _hasRolesFuture =
          authProvider.hasOneOfRoles([Role.guardian, Role.pupil, Role.teacher]);
    });

    Pupil? childData;

      if (authProvider.userRole!.hasRole(Role.pupil) || authProvider.userRole!.hasRole(Role.guardian)) {
        final loggedInUser = UserService.fetchLoggedInUser();
        
        int userId = loggedInUser.id;

        childData = await childService.getByPupilId(userId);

        setState(() {
          _pupil = childData;
        });
    } else if (authProvider.userRole!.hasRole(Role.teacher)) {
      int tempChildId = int.parse(widget.pupil['id']!);
      final childData = await pupilService.getByPupilId(tempChildId);
      setState(() {
        _pupil = childData;
      });
    }

    if(childData != null) {
      setState(() {
        _callerFuture = caller();
      });
    } else if (childData == null) {
      throw Exception('ChildData er null');
    }
  }


  Future<void> caller() async {
    final mealNotifier = Provider.of<MealNotifier>(context, listen: false);

    await mealNotifier().teacherUpdateChildId(_pupil!.guardianId);
    await mealNotifier().updateDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: userRole!.hasRole(Role.teacher) ||userRole!.hasRole(Role.admin)
            ? IconButton(
                onPressed: () {
                  GoRouter.of(context).go(TEACHER_ROOT);
                },
                icon: Icon(SFIcons.sf_chevron_backward),
              )
            : null,
        title: Text(
          '${_pupil?.firstName} ${_pupil?.lastName}',
          style: AppTextStyles.headline4,
        ),
        centerTitle: true,
        actions: !(userRole!.hasRole(Role.teacher)) && !(userRole!.hasRole(Role.admin))
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
                              'childId': _pupil!.pupilId.toString()
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
