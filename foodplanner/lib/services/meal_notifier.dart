import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:foodplanner/models/user_roles.dart';
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
  int? teacherChildId;

  MealNotifier({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              iOptions:
                  IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            ) {
    fetchMealData();
  }

  Future<void> updateDate(DateTime date) async {
    selectedDate = date;
    await _secureStorage.write(
        key: '_selectedDate', value: selectedDate.toString());
    await fetchMealData();
    notifyListeners();
  }

  Future<void> fetchMealData() async {
    //debugPrint('Step1: Start fetchMealData()');
    selectedDate = DateTime.parse(await _secureStorage.read(key: '_selectedDate') ??
            DateFormat('yyyy-MM-dd').format(DateTime.now()));
    //debugPrint('Step2: selectedDate = $selectedDate');
    
    final mealService = MealService(apiUrl: baseUrl);
    
    //debugPrint('Step3: Retrieving role..');
    final role = await AuthProvider().retrieveRole();
    if(role == null){developer.log("Role was null"); return;}
    Meal? mealData;
    if (role.hasRole(Role.pupil) || role.hasRole(Role.guardian)) {
      mealData = await mealService
          .fetchMealData(DateFormat('yyyy-MM-dd').format(selectedDate));
      //debugPrint('Step4 done: mealdata = $mealData');
      
    } else if(role.hasRole(Role.teacher) || role.hasRole(Role.admin)) {
      //debugPrint('Step5: Reading teacherChildId from storage...');
      final teacherChildIdStr =
          await _secureStorage.read(key: '_teacherChildId');
      //debugPrint('Step5 done: teacherChildStr = $teacherChildIdStr');

      if (teacherChildIdStr != null) {
        teacherChildId = int.parse(teacherChildIdStr);
      } else {
        debugPrint('ERROR: eacherChildIdStr was NULL');
      }

      //debugPrint('Step6: Fetching teacher mealData');
      mealData = await mealService.fetchMealDataTeacher(
          DateFormat('yyyy-MM-dd').format(selectedDate), teacherChildId!);
      //debugPrint('Step 6: mealData = $mealData');
    }

    //debugPrint('Step 7');
    meal = mealData;
    notifyListeners();

    //debugPrint('Step 7 done');
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

  Future<void> teacherUpdateChildId(int id) async {
    teacherChildId = id;
    await _secureStorage.write(key: '_teacherChildId', value: id.toString());
    notifyListeners();
  }
}
