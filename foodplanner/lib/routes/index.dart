import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/pages/createMealPage.dart';
import 'package:foodplanner/pages/feedbackChatPage.dart';
import 'package:foodplanner/pages/landing_page_parent.dart';
import 'package:foodplanner/pages/create_child_page.dart';
import 'package:foodplanner/pages/forgot_password_page.dart';
import 'package:foodplanner/pages/home_page.dart';
import 'package:foodplanner/pages/landing_page_teacher.dart';
import 'package:foodplanner/pages/signup_page.dart';
import 'package:foodplanner/pages/landing_page_children_madpakke.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../pages/login_page.dart'; 
import '../pages/unauthorized_page.dart';

// Import HomePage

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => NavBar(),
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
      builder: (context, state) => ChildLandingPageMadpakke(student: {},),
    ),

    GoRoute(path: '/feedback',
      builder: (context, state) => FeedbackChatPage(),
    ),

    GoRoute(path: '/create-meal',
      builder: (context, state) => CreateMealPage(),
    ),  

    GoRoute(path: '/home',
      builder: (context, state) => HomePage(),
    ),

    //no need for wildcard handling as flutter already does it

    GoRoute(
      path: TEACHER_ROOT,
      builder: (context, state) {
         final authProvider = Provider.of<AuthProvider>(context, listen: false);
            return FutureBuilder<bool>(
          future: authProvider.hasRole(ROLES.teacher),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading while waiting
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
          future: authProvider.hasRole(ROLES.teacher),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading while waiting
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
      path: ADMIN_ROOT,
      builder: (context, state) {
         final authProvider = Provider.of<AuthProvider>(context, listen: false);
            return FutureBuilder<bool>(
          future: authProvider.hasRole(ROLES.teacher),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading while waiting
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
      path: PARENT_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
            return FutureBuilder<bool>(
          future: authProvider.hasRole(ROLES.teacher),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading while waiting
            } else if (snapshot.hasData && snapshot.data == true) {
              return const TeacherLandingPage();
            } else {
              return const UnauthorizedPage();
            }
      },
    );
      },
      routes: [
        GoRoute(
          path: MADPAKKE,
          builder:(context, state) => ParentLandingPageMadpakke(),)
      ]
    ),
  ],
);
