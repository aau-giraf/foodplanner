import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/pages/admin_page.dart';
import 'package:foodplanner/pages/parent_page.dart';
import 'package:foodplanner/pages/student_page.dart';
import 'package:foodplanner/pages/teacher_page.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../auth/auth_provider.dart';
import '../main.dart';
import '../pages/signup.dart';
import '../pages/login.dart';
import '../pages/unauthorized_page.dart';
import '../pages/teacher_page.dart';
import '../pages/student_page.dart';
import '../pages/admin_page.dart';
import '../pages/parent_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(title: 'Flutter Demo Home Page'),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
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
    ),
  ],
);





