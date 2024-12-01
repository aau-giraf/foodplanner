import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';

import 'package:foodplanner/components/mealBox.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/child.dart';
import 'package:foodplanner/pages/landing_page_teacher.dart';

import 'package:foodplanner/pages/pin_code.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/auth/auth_provider.dart';

class ChildLandingPageMadpakke extends StatefulWidget {
  final Map<String, String> student;
  const ChildLandingPageMadpakke(
      {super.key, /* required Map<String, String> */ required this.student});

  @override
  _ChildLandingPageMadpakkeState createState() =>
      _ChildLandingPageMadpakkeState();
}

class _ChildLandingPageMadpakkeState extends State<ChildLandingPageMadpakke> {
  late Future<bool> _hasRolesFuture;
  Child? _child;
  final ChildService childService = ChildService(apiUrl: ApiConfig.baseUrl);
  String? userRole;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //_hasRolesFuture = authProvider.hasRoles([ROLES.parent, ROLES.student]);
    authProvider.loadFromStorage().then((_) {
      authProvider.retrieveToken().then((token) async {
        final role = await authProvider.retrieveRole();
        setState(() {
          userRole = role?.toString();
          _hasRolesFuture = authProvider
              .hasRoles([ROLES.parent, ROLES.student, ROLES.teacher]);
          if (authProvider.userRole == ROLES.student ||
              authProvider.userRole == ROLES.parent) {
            childService.fetchChildById().then((childData) {
              setState(() {
                _child = childData;
                print(_child!.firstName);
              });
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: userRole == ROLES.teacher.toString()
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
        actions: userRole != ROLES.teacher.toString()
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
      bottomNavigationBar: NavBar(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ReusableMealBox(),
                  ), // Use the reusable widget
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
