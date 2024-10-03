import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final dynamic hintText;
  final dynamic obscureText;
  final dynamic color;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.obscureText = false, // default value
      this.color = AppColors.textFieldBackground // default color
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 150),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldBorder),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.textFieldBorderFocus),
              borderRadius: BorderRadius.circular(10)),
          fillColor: color,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textFieldHint),
        ),
      ),
    );
  }
}
