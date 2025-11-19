import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/meal_box.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:foodplanner/routes/paths.dart';

import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ParentLandingPageMadpakke extends StatefulWidget {
  const ParentLandingPageMadpakke({super.key});

  @override
  State<ParentLandingPageMadpakke> createState() =>
      ParentLandingPageMadpakkeState();
}

class ParentLandingPageMadpakkeState extends State<ParentLandingPageMadpakke> {
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
  Widget build(BuildContext context) {
    // Get the size of the screen
    final mealNotifier = Provider.of<MealNotifier>(context);

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
                    'Velkommen ${_user?.firstName ?? 'Elev'}',
                    style: AppTextStyles.headline4,
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    await AuthProvider().setRole(ROLES.student);
                    await AuthProvider().loadFromStorage();
                    GoRouter.of(context).go('/');
                  },
                  icon: SFIcon(SFIcons.sf_lock_open_fill)),
            ],
          ),
        ),
        leadingWidth: double.infinity,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: NavBar(currentPageIndex: 1),
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
                    child: ReusableMealBox(),
                  ), // Use the reusable widget
                  SizedBox(height: 20),
                  mealNotifier.meal == null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomButton(
                            onTab: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MealFormPage()),
                              ).then((_) {
                                mealNotifier.fetchMealData();
                              });
                            },
                            icon: SFIcon(
                              SFIcons.sf_plus,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomButton(
                            onTab: () {
                              GoRouter.of(context).go(FEEDBACK_Page);
                            },
                            text: 'Se Feedback',
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

/*
import 'package:flutter/material.dart';

class StudentPage extends StatelessWidget {
   const StudentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Page'), 
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to the Student Page!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text('Click Me'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
*/