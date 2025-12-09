import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/loading_animation.dart';
import 'package:foodplanner/pages/admin/profiles/admin_profiles.dart';
import 'package:foodplanner/pages/Change_Roll.dart';
import 'package:foodplanner/pages/change_role_page.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:foodplanner/pages/choose_child_teacher.dart';
import 'package:foodplanner/pages/create_pupil_page.dart';
import 'package:foodplanner/pages/feedback_chat_page.dart';
import 'package:foodplanner/pages/forgot_password_page.dart';
import 'package:foodplanner/pages/home_page.dart';
import 'package:foodplanner/pages/main_page_admin_teacher.dart';
import 'package:foodplanner/pages/main_page_admin.dart';
import 'package:foodplanner/pages/landing_page_children_madpakke.dart';
import 'package:foodplanner/pages/main_page_parent.dart';
import 'package:foodplanner/pages/main_page_teacher.dart';
import 'package:foodplanner/pages/admin_administration/SchoolClasses.dart';
import 'package:foodplanner/pages/settings/settings.dart';
import 'package:foodplanner/pages/meal_list_page.dart';
import 'package:foodplanner/pages/profile_page.dart';
import 'package:foodplanner/pages/signup_page_adult.dart';
import 'package:foodplanner/pages/signup_page_base.dart';
import 'package:foodplanner/pages/signup_page_pupil.dart';
import 'package:foodplanner/pages/main_page_student.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/pages/choose_child_parent.dart';


import '../pages/login_page.dart';
import '../pages/unauthorized_page.dart';

// Import HomePage

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        
        if(!authProvider.isLoggedIn) {
          return '/login';
        }

        return null;
        /*final role = await authProvider.retrieveRole();
        final isLoggedIn = authProvider.isLoggedIn;
        if (!isLoggedIn) {
          return '/login';
        }
        if(role == null){developer.log("Role was null"); return null;} 

        if(role.hasOneOfRoles({Role.teacher, Role.admin})){return TEACHER_ROOT;}
        else if (role.hasRole(Role.parent)){return PARENT_ROOT;}
        else {return STUDENT_ROOT;}
*/
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignupPageAdult(),
    ),
    GoRoute(
      path: '/signup/create-child',
      builder: (context, state) => CreatePupilPage(),
    ),
    GoRoute(
      path: '/unauthorized',
      builder: (context, state) => UnauthorizedPage(),
    ),

    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordPage(),
    ),

    GoRoute(
      path: '/children_se_madpakke',
      builder: (context, state) => PupilLandingPageMadpakke(
        pupil: {},
      ),
    ),

    GoRoute(
      path: '/parent_landing_page',
      builder: (context, state) => ParentMainPage(),
    ),

    GoRoute(
      path: '/feedback',
      builder: (context, state) => FeedbackChatPage(),
    ),

    GoRoute(
      path: '/create-meal',
      builder: (context, state) => MealFormPage(),
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) => HomePage(),
    ),

    GoRoute(
      path: '/empty',
      builder: (context, state) => MealListPage(),
    ),
    GoRoute(
      path: '/student-details',
      builder: (context, state) {
        final student = state.extra as Map<String, String?>;
        return PupilLandingPageMadpakke(
            pupil: student.cast<String, String>());
      },
    ),

    GoRoute(path: CHOOSE_CHILD_PARENT,
      builder: (context, state) => ChooseChildGuardian(),
    ),
   
    GoRoute(path: CHOOSE_CHILD_TEACHER,
      builder: (context, state) => ChooseChildTeacher(),
    ),

    GoRoute(path: ADMIN_TEACHER_ROOT,
      builder: (context, state) => TeacherMainPage(),
    ),


    GoRoute(path: ADMIN_PROFILES_PAGE,
      builder: (context, state) => AdminProfilesPage(),
    ),

    GoRoute(path: ADMIN_SCHOOL, 
      builder: (context, state) => SchoolClasses(),
    ),
/*
    GoRoute(path: '/madpakke',
      builder: (context, state) => EditMealFormPage();
    ),
*/

    //no need for wildcard handling as flutter already does it
    GoRoute(
      path: TEACHER_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future: authProvider.hasOneOfRoles([Role.teacher, Role.admin]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingAnimation(
                  imagePath:
                      'assets/images/logo.png', // Replace with your image path
                  size: 50.0,
                ),
              ); // Show loading while waiting
            } else if (snapshot.hasData && snapshot.data == true) {
              return const TeacherMainPage();
            } else {
              return const UnauthorizedPage();
            }
          },
        );
      },
    ),
    GoRoute(
      path: STUDENT_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future: authProvider.hasOneOfRoles([Role.pupil, Role.admin]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingAnimation(
                  imagePath:
                      'assets/images/logo.png', // Replace with your image path
                  size: 50.0,
                ),
              ); // Show loading while waiting
            } else if (snapshot.hasData && snapshot.data == true) {
              return const PupilLandingPageMadpakke(
                pupil: {},
              ); //im guessing this page, student_page is a dummy page
            } else {
              return const UnauthorizedPage();
            }
          },
        );
      },
    ),

    GoRoute(
      path: STUDENT_CREATE,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future: authProvider.hasOneOfRolesUnapproved([Role.pupil]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingAnimation(
                  imagePath:
                      'assets/images/logo.png', // Replace with your image path
                  size: 50.0,
                ),
              ); // Show loading while waiting
            } else if (snapshot.hasData && snapshot.data == true) {
              return const CreatePupilPage();
            } else {
              return const UnauthorizedPage();
            }
          },
        );
      },
    ),
    GoRoute(
      path: SETTINGS_PAGE,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future:
              authProvider.hasOneOfRoles([Role.guardian, Role.teacher, Role.admin, Role.pupil]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingAnimation(
                  imagePath:
                      'assets/images/logo.png', // Replace with your image path
                  size: 50.0,
                ),
              ); // Show loading while waiting
            } else if (snapshot.hasData && snapshot.data == true) {
              return const Settings();
            } else {
              return const UnauthorizedPage();
            }
          },
        );
      },
    ),
    GoRoute(
      path: PROFILE_PAGE,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future:
              authProvider.hasOneOfRoles([Role.guardian, Role.teacher, Role.admin]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingAnimation(
                  imagePath:
                      'assets/images/logo.png', // Replace with your image path
                  size: 50.0,
                ),
              ); // Show loading while waiting
            } else if (snapshot.hasData && snapshot.data == true) {
              return const GuardianProfile();
            } else {
              return const UnauthorizedPage();
            }
          },
        );
      },
    ),
    GoRoute(
      path: FEEDBACK_Page,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future:
              authProvider.hasOneOfRoles([Role.guardian, Role.teacher, Role.admin, Role.pupil]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingAnimation(
                  imagePath:
                      'assets/images/logo.png', // Replace with your image path
                  size: 50.0,
                ),
              ); // Show loading while waiting
            } else if (snapshot.hasData && snapshot.data == true) {
              return const FeedbackChatPage();
            } else {
              return const UnauthorizedPage();
            }
          },
        );
      },
    ),
    GoRoute(
      path: ADMIN_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future: authProvider.hasOneOfRoles([Role.admin]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingAnimation(
                  imagePath:
                      'assets/images/logo.png', // Replace with your image path
                  size: 50.0,
                ),
              ); // Show loading while waiting
            } else if (snapshot.hasData && snapshot.data == true) {
                return const AdminLandingPage();

              /*return Column(
                children: [
                  const Text('Admin Page'),
                  NavBar(),
                ],
              ); // another dummy page, I think Dressi is making a new one TODO
              */
            } else {
              return const UnauthorizedPage();
            }
          },
        );
      },
    ),

    GoRoute(
        path: PARENT_ROOT,
        builder: (context, state) {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          return FutureBuilder<bool>(
            future: authProvider.hasOneOfRoles([Role.guardian, Role.admin]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: LoadingAnimation(
                    imagePath:
                        'assets/images/logo.png', // Replace with your image path
                    size: 50.0,
                  ),
                ); // Show loading while waiting
              } else if (snapshot.hasData && snapshot.data == true) {
                return const ParentMainPage(); // This should be fine
              } else {
                return const UnauthorizedPage();
              }
            },
          );
        },
        //whats this?
        /*
        routes: [
          GoRoute(
            path: MADPAKKE,
            builder: (context, state) => ParentLandingPageMadpakke(),
          )
        ]),
  ],*/
),

      GoRoute(
      path: STUDENT_UNLOCKED,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future: authProvider.hasOneOfRoles([Role.pupil, Role.pupil]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingAnimation(
                  imagePath:
                      'assets/images/logo.png', // Replace with your image path
                  size: 50.0,
                ),
              ); // Show loading while waiting
            } else if (snapshot.hasData && snapshot.data == true) {
              return const ParentLandingPageMadpakke(); // im guessing this page, student_page is a dummy one it seems TODO
              
            } else {
              return const UnauthorizedPage();
            }
          },
        );
      },
      ),

      GoRoute(
      path: ADMIN_ROLES_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future: authProvider.hasOneOfRoles([Role.admin, Role.teacher]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LoadingAnimation(
                  imagePath:
                      'assets/images/logo.png', // Replace with your image path
                  size: 50.0,
                ),
              ); // Show loading while waiting
            } else if (snapshot.hasData && snapshot.data == true) {
                return const RoleSelectionPage();
              /*return Column(
                children: [
                  const Text('Admin Page'),
                  NavBar(),
                ],
              ); // another dummy page, I think Dressi is making a new one TODO
              */
            } else {
              return const UnauthorizedPage();
            }
          },
        );
      },
    ),

  ],
);
