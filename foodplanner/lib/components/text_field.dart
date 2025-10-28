import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

enum TextFieldType { defaultTextField, smallTextField }

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String errorText;
  final dynamic hintText;
  final dynamic obscureText;
  final dynamic color;
  final TextFieldType type;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.errorText,
    required this.hintText,
    this.obscureText = false, // default value
    this.color = AppColors.textFieldBackground, // default color
    this.type = TextFieldType.defaultTextField, // default type
    this.onChanged,
    this.inputFormatters,
    this.focusNode,
  });

  Widget defaultTextField() {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          textAlign: TextAlign.center,
          cursorColor: AppColors.primary,
          cursorErrorColor: AppColors.errorText,
          inputFormatters: inputFormatters,
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
          onChanged: onChanged,
          focusNode: focusNode,
        ),
        
        errorText.isNotEmpty && errorText != ' '
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(errorText, style: AppTextStyles.errorText),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Widget smallTextField() {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textAlign: TextAlign.left,
      cursorColor: AppColors.primary,
      cursorErrorColor: AppColors.errorText,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        fillColor: color,
        filled: true,
        hintText: hintText,
        hintStyle: AppTextStyles.bigText.copyWith(
            color: AppColors.textFieldHint, fontWeight: FontWeight.w500),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (type == TextFieldType.smallTextField) {
      return smallTextField();
    } else {
      return defaultTextField();
    }
  }
}
