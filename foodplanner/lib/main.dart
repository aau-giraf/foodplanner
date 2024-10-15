import 'package:flutter/material.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/pages/login_page.dart';
import 'package:foodplanner/pages/login_start.dart';
import 'package:foodplanner/pages/signup_page.dart';
import 'package:foodplanner/pages/admin_approve_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavBar(),
    );
  }
}
