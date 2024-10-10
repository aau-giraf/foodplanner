import 'package:flutter/material.dart';

class StrengthBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final dynamic color;

  const StrengthBar({
    Key? key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.onChanged,
    this.color = const Color(0xffF3F8F2), // default color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 150),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: color,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// PasswordStrengthBar widget
class PasswordStrengthBar extends StatelessWidget {
  final double strength;

  const PasswordStrengthBar({Key? key, required this.strength}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the color based on the strength value
    Color getColor() {
      if (strength <= 0.25) return Colors.red;
      if (strength <= 0.5) return Colors.orange;
      if (strength <= 0.75) return Colors.yellow;
      return Colors.green;
    }

    // Determine the text based on the strength value
    String getStrengthText() {
      if (strength <= 0.25) return "Svag";
      if (strength <= 0.5) return "Okay";
      if (strength <= 0.75) return "Strækt";
      return "Meget Strækt";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 300), // Padding around the entire bar
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: strength > 0 ? 15 : 5), // Adjust padding based on strength
              child: Container(
                width: MediaQuery.of(context).size.width / 3, // Set width to 1/3 of the screen
                height: strength > 0 ? 15 : 0, // Set height to 15 only if strength > 0
                decoration: BoxDecoration(
                  color: const Color(0xFFEBE9E9), // Background color of the bar
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                  border: strength > 0
                      ? Border.all(color: Colors.black) 
                      : Border.all(color: Colors.transparent), 
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Ensure corners stay rounded
                  child: LinearProgressIndicator(
                    value: strength > 0 ? strength : 0, // Show progress only if strength > 0
                    backgroundColor: Colors.transparent, // Keep the background transparent
                    valueColor: AlwaysStoppedAnimation<Color>(getColor()), // Progress bar color
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Conditionally render the strength text based on strength value
          if (strength > 0) ...[
            Text(
              getStrengthText(), // Display strength text based on password strength
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Black text color
              ),
            ),
          ],
        ],
      ),
    );
  }
}
