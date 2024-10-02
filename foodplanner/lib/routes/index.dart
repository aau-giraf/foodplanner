import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';
import 'user_roles.dart'; // enum med rollerne, vi kalder det senere med en authProvider
import '../pages/login.dart';
import '../routes/paths.dart';




bool isLoggedIn = false; 


final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(title: 'Flutter Demo Home Page'),
    ),
    GoRoute(
      path: LOGIN_PAGE,
      builder:(context, state) => const LoginPage(),
      ),


  ],
);





