import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodplanner/models/meal.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_provider.dart';

class MealService {
  final String apiUrl;

  MealService({required this.apiUrl});

  Future<Meal?> fetchMealData(String date) async {
    //print("Fetching meal data for date: $date");
    try {
      final jwtToken = await AuthProvider().retrieveToken();
      final response = await http.get(
        Uri.parse('$apiUrl/api/Meals/GetAllByUser/$date'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isEmpty) {
          return null;
        }
        final Map<String, dynamic> mealData = data[0];
        return Meal.fromJson(mealData);
      } else {
        throw Exception('Failed to load meal data');
      }
    } catch (e) {
      print('Error fetching meal data: $e');
      return null;
    }
  }

  Future<Meal?> fetchMealDataTeacher(String date, int id) async {
    //debugPrint("Fetching meal data for date: $date");
    //debugPrint('ChildId: $id');

    try {
      final jwtToken = await AuthProvider().retrieveToken();
      //debugPrint(' -> JWT: ${jwtToken?.substring(0,20)}...');

      final response = await http.get(
        Uri.parse('$apiUrl/api/Meals/TeacherGetUserMeals?date=$date&id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken',
        },
      );

      //debugPrint('Response status: ${response.statusCode}');
      //debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        //debugPrint('response.body: ${response.body}');
        final data = jsonDecode(response.body);
        //debugPrint('meal data: $data');
        if (data.isEmpty) {
          return null;
        }
        final Map<String, dynamic> mealData = data[0];
        return Meal.fromJson(mealData);
      } else {
        throw Exception('Failed to load meal data');
      }
    } catch (e) {
      debugPrint('Error fetching meal data: $e');
      return null;
    }
  }
}
