import 'package:flutter/material.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

// Custom widget for an icon button with optional text label
class CustomIconButton extends StatelessWidget {
  final Function()? onTab; // Callback function to handle button tap
  final Icon icon; // Icon to be displayed on the button
  final String text; // Optional text to be displayed below the icon
  final Color mainColor; // Main color of the icon
  
  // Constructor for the CustomIconButton with required parameters and default values
  const CustomIconButton({
    super.key,
    required this.onTab, // Must orovide a function for the button tap
    required this.icon, // Must provide an icon
    this.text = '', // Default is an empty string for the text
    this.mainColor = AppColors.primary, // Default color 
  });

  @override
  Widget build(BuildContext context) {
    return Column (
      children: [
        SizedBox(height: 8), // Spacer above the icon button
        IconButton (
          icon: icon, // The icon to display
            onPressed: onTab, // Function to call on button press
          style: ElevatedButton.styleFrom( 
            iconColor: mainColor, // Set the color of the icon 
          ),
        ),
        Text(
          text, // Display the text blow the icon
          style: AppTextStyles.standard, // Use standard text style
        ),
      ]
    );
  }
}

// Custom widget for an elevated button that can take custom properties
class CustomElevatedButton extends StatelessWidget {
  final Function()? onTab;   // Callback function to handle button tap
  final String text; // Optional text for the button
  final double height; // Height of the button
  final double width; // Width of the button
  final Color backgroundColor; // Background color of the button
  final Widget widget; // Widget to display inside the button (default is a Text widget)

  // Constructor for the CustomElevatedButton with required parameters and default values
  const CustomElevatedButton({
    super.key,
    required this.onTab, // Must provide a function for the button top
    this.text = '', // Deault is an empty string for the text
    this.height = 50, // Deault height of the button 
    this.width = 100, // Deault width of the button 
    this.backgroundColor = AppColors.primary, // Default background color
    this.widget = const Text('Button', style: AppTextStyles.buttonText,), // Default widget
  });

  @override
  Widget build(BuildContext context) {
    return Container (
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height/2), // Rounded corners based on height
        boxShadow: [
            // Adding shadow effect to the button for a raised appearance
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
              spreadRadius: 1, // Spread of the shadow
              blurRadius: 1, // Blur radius for the shadow
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
      ),
      child: ElevatedButton(
        child: widget, // The child widget (e.g., text) inside the button
        onPressed: onTab, // Function to call on button press
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor, // Set background color of the 
          minimumSize: Size(width, height), // Set minimum size of the button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height/2)  // Rounded shape of the button
          ),
        ),
      ),
    );
  }
  
}