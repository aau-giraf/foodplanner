import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/mealBox.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/child.dart';
import 'package:foodplanner/pages/pin_code.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/child_service.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChildLandingPageMadpakke extends StatefulWidget {
  final Map<String, String> student;
  const ChildLandingPageMadpakke(
      {super.key, /* required Map<String, String> */ required this.student});

  @override
  State<ChildLandingPageMadpakke> createState() =>
      _ChildLandingPageMadpakkeState();
}

class _ChildLandingPageMadpakkeState extends State<ChildLandingPageMadpakke> {
  late Future<bool> _hasRolesFuture;
  Child? _child;
  final ChildService childService = ChildService(apiUrl: ApiConfig.baseUrl);

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //_hasRolesFuture = authProvider.hasRoles([ROLES.parent, ROLES.student]);
    authProvider.loadFromStorage().then((_) {
      authProvider.retrieveToken().then((token) {
        setState(() {
          _hasRolesFuture =
              authProvider.hasRoles([ROLES.parent, ROLES.student]);
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
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    '${_child?.firstName} ${_child?.lastName}',
                    style: AppTextStyles.headline4,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PinCode()),
                    );
                  },
                  icon: SFIcon(SFIcons.sf_lock_fill)),
            ],
          ),
        ),
        leadingWidth: double.infinity,
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
                      future: MealNotifier().updateDate(DateTime.now()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ReusableMealBox();
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
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
