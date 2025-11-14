import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/loading_animation.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/pages/Change_Roll.dart';
import 'package:foodplanner/pages/add_meal_form_page.dart';
import 'package:foodplanner/pages/create_child_page.dart';
import 'package:foodplanner/pages/feedback_chat_page.dart';
import 'package:foodplanner/pages/forgot_password_page.dart';
import 'package:foodplanner/pages/home_page.dart';
import 'package:foodplanner/pages/landing_page_children_madpakke.dart';
import 'package:foodplanner/pages/landing_page_parent.dart';
import 'package:foodplanner/pages/landing_page_teacher.dart';
import 'package:foodplanner/pages/settings/settings.dart';
import 'package:foodplanner/pages/meal_list_page.dart';
import 'package:foodplanner/pages/profile_page.dart';
import 'package:foodplanner/pages/signup_page.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/pages/landing_page_admin.dart';
import '../pages/login_page.dart';
import '../pages/unauthorized_page.dart';

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
        switch (role) {
          case ROLES.teacher:
            return TEACHER_ROOT;
          case ROLES.admin:
            return ADMIN_ROOT;
          case ROLES.parent:
            return PARENT_ROOT;
          default:
            return STUDENT_ROOT;
        }
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
      builder: (context, state) => CreateChildPage(),
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
      builder: (context, state) => ChildLandingPageMadpakke(
        student: {},
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
        return ChildLandingPageMadpakke(
            student: student.cast<String, String>());
      },
    ),

    //no need for wildcard handling as flutter already does it

    GoRoute(
      path: TEACHER_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future: authProvider.hasRoles([ROLES.teacher, ROLES.admin]),
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
    GoRoute(
      path: STUDENT_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return FutureBuilder<bool>(
          future: authProvider.hasRoles([ROLES.student, ROLES.admin]),
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
              return const ChildLandingPageMadpakke(
                student: {},
              ); // im guessing this page, student_page is a dummy one it seems TODO
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
          future: authProvider.hasRolesUnapproved([ROLES.student]),
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
              return const CreateChildPage(); // im guessing this page, student_page is a dummy one it seems TODO
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
              authProvider.hasRoles([ROLES.parent, ROLES.teacher, ROLES.admin]),
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
              return const Settings(); // im guessing this page, student_page is a dummy one it seems TODO
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
              authProvider.hasRoles([ROLES.parent, ROLES.teacher, ROLES.admin]),
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
              return const ParentProfile();
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
              authProvider.hasRoles([ROLES.parent, ROLES.teacher, ROLES.admin]),
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
              return const FeedbackChatPage(); // im guessing this page, student_page is a dummy one it seems TODO
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
          future: authProvider.hasRoles([ROLES.admin]),
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
              ); // another dummy page, I think Dressi is making a new one TODO*/
              
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
            future: authProvider.hasRoles([ROLES.parent, ROLES.admin]),
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
                return const ParentLandingPageMadpakke(); // This should be fine
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
            builder: (context, state) => ParentLandingPageMadpakke(),
          )
        ]),
  ],
);
