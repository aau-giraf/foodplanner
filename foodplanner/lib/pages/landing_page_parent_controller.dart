import 'package:flutter/material.dart';
import 'package:foodplanner/pages/landing_page_parent.dart';
import 'package:foodplanner/pages/landing_page_parent_empty.dart';

class LandingPageParentController extends StatelessWidget {
  const LandingPageParentController({super.key});
  


  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool hasMadpakke = false;
      if (hasMadpakke) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ParentLandingPageMadpakke()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ParentLandingPageMadpakkeEmpty()),
        );
      }
    });

    // Return an empty container while the navigation is being handled
    return Container();
  }
}