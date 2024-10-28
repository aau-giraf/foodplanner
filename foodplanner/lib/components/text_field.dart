import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String errorText;
  final dynamic hintText;
  final dynamic obscureText;
  final dynamic color;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.errorText,
      required this.hintText,
      this.obscureText = false, // default value
      this.color = AppColors.textFieldBackground // default color
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          textAlign: TextAlign.center,
          cursorColor: AppColors.primary,
          cursorErrorColor: AppColors.errorText,
          decoration: InputDecoration(
            fillColor: color,
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(color: AppColors.textFieldHint),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: errorText.isEmpty
                      ? AppColors.textFieldBorderFocus
                      : AppColors.errorText),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: errorText.isEmpty
                      ? AppColors.textFieldBorder
                      : AppColors.errorText),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.errorText),
            ),
          ),
        ),
        errorText.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(errorText, style: AppTextStyles.errorText),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
