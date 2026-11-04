import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/loadingAnimation.dart';
import 'package:foodplanner/components/navBar.dart';
import 'package:foodplanner/pages/addMealFormPage.dart';
import 'package:foodplanner/pages/createPupilPage.dart';
import 'package:foodplanner/pages/feedbackChatPage.dart';
import 'package:foodplanner/pages/forgotPasswordPage.dart';
import 'package:foodplanner/pages/homePage.dart';
import 'package:foodplanner/pages/landingPageChildrenMadpakke.dart';
import 'package:foodplanner/pages/landingPageGuardian.dart';
import 'package:foodplanner/pages/landingPageTeacher.dart';
import 'package:foodplanner/pages/settings/settings.dart';
import 'package:foodplanner/pages/mealListPage.dart';
import 'package:foodplanner/pages/profilePage.dart';
import 'package:foodplanner/pages/signupPage.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../pages/loginPage.dart';
import '../pages/unauthorizedPage.dart';

// Import HomePage

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final role = await authProvider.retrieveRole();
        final isLoggedIn = authProvider.isLoggedIn;
        if (!isLoggedIn) {
          return '/login';
        }
        if(role == null){developer.log("Role was null"); return null;}

        if(role.hasOneOfRoles({Role.teacher, Role.admin})){return TEACHER_ROOT;}
        else if (role.hasRole(Role.guardian)){return PARENT_ROOT;}
        else {return STUDENT_ROOT;}

      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignupPage(),
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
              return const TeacherLandingPage();
            } else {
              return const UnauthorizedPage();
            }
          },
        );
      },
    ),
    GoRoute( // This whole thing is most likely redundant and should be removed since it is an auth for students to log in, which should not be possible
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
              );
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
              return Column(
                children: [
                  const Text('Admin Page'),
                  NavBar(),
                ],
              );
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
                return const GuardianLandingPageMadpakke(); // This should be fine
              } else {
                return const UnauthorizedPage();
              }
            },
          );
        },
        //whats this?
        routes: [
          GoRoute(
            path: MADPAKKE,
            builder: (context, state) => GuardianLandingPageMadpakke(),
          )
        ]),
  ],
);
