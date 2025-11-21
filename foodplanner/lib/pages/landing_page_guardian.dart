import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/meal_box.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:foodplanner/pages/edit_meal_page.dart';
import 'package:foodplanner/routes/paths.dart';

import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/meal_notifier.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GuardianLandingPageMadpakke extends StatefulWidget {
  const GuardianLandingPageMadpakke({super.key});

  @override
  State<GuardianLandingPageMadpakke> createState() =>
      GuardianLandingPageMadpakkeState();
}

class GuardianLandingPageMadpakkeState extends State<GuardianLandingPageMadpakke> {
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'Velkommen ${_user?.firstName ?? 'Forældre'}',
                    style: AppTextStyles.headline4,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await AuthProvider().setRole(UserRoles.of({Role.student}));
                  await AuthProvider().loadFromStorage();

                  if (!context.mounted){
                    developer.log('buildcontext is not mounted, in $runtimeType');
                    return;
                  }

                  GoRouter.of(context).go('/');
                },
                icon: SFIcon(SFIcons.sf_lock_open_fill)
              ),
            ],
          ),
        ),
        leadingWidth: double.infinity,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      bottomNavigationBar: NavBar(),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
                  )
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(
                    onTab: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditMealPage()));
                            },

                          // Burde nok alignes center i fremtiden
                            text: 'Se og Redigér\n   Madpakke',
                    //fontSize: 16,
                  ),
                ),
        ],
      ),
    );
  }
}
