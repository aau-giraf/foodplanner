import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTab;
  final String text;
  final Color mainColor;
  final double fontSize; // New parameter for font size
  final double width; // New parameter for width
  final double height; // New parameter for height

  const CustomButton({
    super.key,
    required this.onTab,
    this.text = 'Login', // default text
    this.mainColor = AppColors.primary, // default color
    this.fontSize = 16.0, // default font size
    this.width = 150.0, // default width
    this.height = 50.0, // default height
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        width: width, // Use the width parameter
        height: height, // Use the height parameter
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(30), // Make it rounded
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.buttonText.copyWith(fontSize: fontSize), // Use the font size parameter
          ),
        ),
      ),
    );
  }
}