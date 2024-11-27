import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/models/packed_ingredient.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/fetch_meal.dart';
import 'package:intl/intl.dart';

class MealNotifier with ChangeNotifier {
  final FlutterSecureStorage _secureStorage;
  DateTime selectedDate = DateTime.now();
  String mealTitle = '';
  String mealImageRef = '';
  bool isMealEmpty = true;
  String baseUrl = ApiConfig.baseUrl;
  Meal? meal;

  MealNotifier({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              iOptions:
                  IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            ) {
    fetchMealData();
  }

  void updateDate(DateTime date) async {
    selectedDate = date;
    await fetchMealData();
    notifyListeners();
  }

  Future<void> fetchMealData() async {
    final mealService = MealService(apiUrl: baseUrl);
    final mealData = await mealService
        .fetchMealData(DateFormat('yyyy-MM-dd').format(selectedDate));

    meal = mealData;
    notifyListeners();
  }

  Future<DateTime> retrieveDate() async {
    selectedDate = DateTime.parse(
        await _secureStorage.read(key: '_selectedDate') ??
            DateFormat('yyyy-MM-dd').format(DateTime.now()));
    notifyListeners();

    return selectedDate;
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
      await _secureStorage.write(
          key: '_selectedDate', value: selectedDate.toString());
      await fetchMealData();
    }
  }
}
