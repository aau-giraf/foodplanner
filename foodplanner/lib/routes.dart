import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';



bool isLoggedIn = false; 


final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(title: 'Flutter Demo Home Page'),
    ),
    GoRoute(
      path: '/login' 
      ),
      

  ],
);





