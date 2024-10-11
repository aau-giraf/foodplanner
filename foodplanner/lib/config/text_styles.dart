import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';

class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary, // You can use AppColors here if needed
  );

  static const TextStyle headline1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary, // You can use AppColors here if needed
  );

  static const TextStyle standard = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle bigText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle errorText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.errorText,
  );
}
