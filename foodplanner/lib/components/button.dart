import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

// Enum to represent different button sizes
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final Function()? onTab;
  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final ButtonSize? size; // Optional size parameter
  final double? customWidth; // Optional custom width
  final double? customHeight; // Optional custom height

  const CustomButton({
    super.key,
    required this.onTab,
    required this.text,
    this.backgroundColor = AppColors.primary, // Default background color
    this.foregroundColor = AppColors.textSecondary, // Default foreground color
    this.size, // Size parameter
    this.customWidth, // Custom width
    this.customHeight, // Custom height
  });

  @override
  Widget build(BuildContext context) {
    // Define default dimensions based on button size
    double width;
    double height;

    // Check if a custom width is provided
    if (customWidth != null) {
      width = customWidth!;
    } else {
      // Default to double.infinity for width
      width = double.infinity;
    }

    // Set height based on size parameter
    if (size != null) {
      switch (size) {
        case ButtonSize.small:
          height = 35;
          break;
        case ButtonSize.medium:
          height = 60;
          break;
        case ButtonSize.large:
          height = 75;
          break;
        default:
          height = 60; // Fallback to medium if necessary
      }
    } else if (customHeight != null) {
      height = customHeight!;
    } else {
      // Default to medium height if no size is provided
      height = 60;
    }

    // Determine the appropriate text style based on button size
    TextStyle buttonTextStyle;
    EdgeInsetsGeometry buttonPadding;

    switch (size) {
      case ButtonSize.small:
        buttonTextStyle = AppTextStyles.buttonTextSmall;
        buttonPadding = EdgeInsets.symmetric(
            vertical: 4, horizontal: 8); // Adjust padding for small button
        break;
      case ButtonSize.medium:
        buttonTextStyle = AppTextStyles.buttonTextMedium;
        buttonPadding = EdgeInsets.symmetric(
            vertical: 8, horizontal: 16); // Adjust padding for medium button
        break;
      case ButtonSize.large:
        buttonTextStyle = AppTextStyles.buttonTextBig;
        buttonPadding = EdgeInsets.symmetric(
            vertical: 12, horizontal: 24); // Adjust padding for large button
        break;
      default:
        buttonTextStyle = AppTextStyles.buttonTextMedium; // Fallback to medium
        buttonPadding = EdgeInsets.symmetric(
            vertical: 8, horizontal: 16); // Default padding
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onTab,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledForegroundColor: foregroundColor.withOpacity(0.5),
          elevation: 3,
          padding: buttonPadding, // Set the padding for the button
        ),
        child: Text(
          text,
          style: buttonTextStyle, // Use the determined text style
        ),
      ),
    );
  }
}
