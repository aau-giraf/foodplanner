import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'dart:math';

class CustomButton extends StatelessWidget {
  final Function()? onTab;
  final String text;
  final Color mainColor;
  final EdgeInsets horizontalMargin;
  final double? width;
  final double? height;
  final double? fontSize;

  const CustomButton({
    super.key,
    required this.onTab,
    this.text = 'Login', // default text
    this.mainColor = AppColors.primary, // default color
    this.horizontalMargin =
        const EdgeInsets.symmetric(horizontal: 150), // default margin
    this.width, // dynamic width
    this.height, // dynamic height
    this.fontSize, // dynamic font size
  });

  @override
  Widget build(BuildContext context) {
    // Get device dimensions
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    // Define base sizes
    final baseWidth = 100.0;
    final baseHeight = 50.0;
    final baseFontSize = 16.0;

    // Calculate dynamic sizes based on base sizes and device dimensions
    final dynamicWidth = width ?? baseWidth * sqrt(deviceWidth / 375.0);
    final dynamicHeight = height ?? baseHeight * sqrt(deviceHeight / 667.0);
    final dynamicFontSize =
        fontSize ?? baseFontSize * sqrt(deviceWidth / 375.0);

    final adjustedWidth = orientation == Orientation.landscape
        ? dynamicWidth * 1.2
        : dynamicWidth;
    final adjustedHeight = orientation == Orientation.landscape
        ? dynamicHeight * 1
        : dynamicHeight;
    final adjustedFontSize = orientation == Orientation.landscape
        ? dynamicFontSize * 1.1
        : dynamicFontSize;

    return GestureDetector(
      onTap: onTab,
      child: Container(
        width: dynamicWidth,
        height: dynamicHeight,
        padding: EdgeInsets.all(15),
        margin: horizontalMargin,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.buttonText.copyWith(
              fontSize: dynamicFontSize, // default font size if not provided
            ),
          ),
        ),
      ),
    );
  }
}
