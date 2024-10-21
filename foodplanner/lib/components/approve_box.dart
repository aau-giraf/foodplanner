import 'package:flutter/material.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'button.dart';
import 'package:foodplanner/config/colors.dart';

class ApproveBox extends StatelessWidget {
  final String name;
  final String LastName;
  final String role;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  ApproveBox({
    required this.name,
    required this.role,
    required this.LastName,
    required this.onApprove,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(179, 255, 255, 255),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Ensure text is on left, buttons on right
        children: [
          // Name and Role Text
          Expanded(
            child: Text(
              '$name $LastName vil gerne være $role',
              style: AppTextStyles.standard, // Ensure text color contrast
            ),
          ),
          // Add a SizedBox for spacing between text and buttons
          SizedBox(width: 16.0), // Adjust this value for desired space

          // Buttons aligned to the right
          Row(
            children: [
              CustomButton(
                onTab: onApprove,
                text: 'Godkend',
                backgroundColor: AppColors.primary,
                customWidth: 80,
                size: ButtonSize.small,
              ),
              SizedBox(width: 8.0),
              CustomButton(
                onTab: onDeny,
                text: 'Afvis',
                backgroundColor: AppColors.secondary,
                customWidth: 80,
                size: ButtonSize.small,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
