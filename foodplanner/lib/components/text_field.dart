import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final controller;
  final errorText;
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 150),
      child: Column(
        children: [
          TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: errorText.isNotEmpty
                        ? AppColors.errorText
                        : AppColors.textFieldBorder,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: errorText.isNotEmpty
                        ? AppColors.errorText
                        : AppColors.textFieldBorderFocus,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              fillColor: color,
              filled: true,
              hintText: hintText,
              hintStyle: const TextStyle(color: AppColors.textFieldHint),
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
      ),
    );
  }
}
