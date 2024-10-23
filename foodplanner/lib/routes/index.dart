import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/pages/admin_page.dart';
import 'package:foodplanner/pages/landing_page_parent.dart';
import 'package:foodplanner/pages/forgot_password_page.dart';
import 'package:foodplanner/pages/parent_page.dart';
import 'package:foodplanner/pages/signup_page.dart';
import 'package:foodplanner/pages/student_page.dart';
import 'package:foodplanner/pages/teacher_page.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:foodplanner/pages/landing_page_parent.dart';
import '../auth/auth_provider.dart';
import '../main.dart';
import '../pages/signup_page.dart';
import '../pages/login_page.dart'; 
import '../pages/unauthorized_page.dart';
import '../pages/home_page.dart'; // Import HomePage

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),
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
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordPage(),
    ),


    //no need for wildcard handling as flutter already does it 
   
    
    GoRoute(
      path: TEACHER_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return authProvider.hasRole(ROLES.teacher) ? const TeacherPage() : const UnauthorizedPage();
      },
    ),
    GoRoute(
      path: STUDENT_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return authProvider.hasRole(ROLES.student) ? const StudentPage() : const UnauthorizedPage();
      },
    ),
    GoRoute(
      path: ADMIN_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return authProvider.hasRole(ROLES.admin) ? const AdminPage() : const UnauthorizedPage();
      },
    ),
    GoRoute(
      path: PARENT_ROOT,
      builder: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        return authProvider.hasRole(ROLES.parent) ? const ParentPage() : const UnauthorizedPage();
      },
      routes: [
        GoRoute(
          path: MADPAKKE,
          builder:(context, state) => ParentLandingPageMadpakke(),)
      ]
    ),
  ],
);





