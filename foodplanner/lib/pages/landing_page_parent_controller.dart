import 'package:flutter/material.dart';
import 'package:foodplanner/pages/landing_page_parent.dart';
import 'package:foodplanner/pages/landing_page_parent_empty.dart';
import 'package:foodplanner/services/fetch_meal.dart';
import 'package:foodplanner/services/api_config.dart';

class LandingPageParentController extends StatelessWidget {
  const LandingPageParentController({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mealService = MealService(apiUrl: ApiConfig.baseUrl);
      final mealData = await mealService.fetchMealData('user123', '2023-10-01'); // needs to be dynamic when we have the endpoints avail.

      bool hasMadpakke = mealData.isNotEmpty && mealData['title'] != null && mealData['title']!.isNotEmpty && mealData['image_ref'] != null && mealData['image_ref']!.isNotEmpty;

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