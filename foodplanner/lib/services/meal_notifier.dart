import 'package:flutter/material.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/fetch_meal.dart';
import 'package:intl/intl.dart';

class MealNotifier extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  String mealTitle = '';
  String mealImageRef = '';
  bool isMealEmpty = true;
  String baseUrl = ApiConfig.baseUrl;

  MealNotifier() {
    _fetchMealData();
  }

  Future<void> _fetchMealData() async {
    final mealService = MealService(apiUrl: baseUrl);
    final mealData = await mealService.fetchMealData(
        // TODO - Replace 'user123' with the actual user id
        DateFormat('yyyy-MM-dd').format(selectedDate));

    mealTitle = mealData['title'] ?? 'No meal available';
    mealImageRef = mealData['image_ref'] ?? '';
    isMealEmpty = mealTitle != 'No meal available';

    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      _fetchMealData();
    }
  }
}
