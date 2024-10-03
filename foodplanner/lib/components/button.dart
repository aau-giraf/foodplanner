import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTab;
  final String text;
  final Color mainColor;

  const CustomButton({
    super.key,
    required this.onTab,
    this.text = 'Login', // default text
    this.mainColor = AppColors.primary, // default color
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 150),
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.buttonText,
          ),
        ),
      ),
    );
  }
}
