import 'package:flutter/material.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'button.dart';
import 'package:foodplanner/config/colors.dart';

class ApproveBox extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback onApprove;
  final VoidCallback onDeny;

  ApproveBox({
    required this.name,
    required this.role,
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
              '$name wants to be a $role',
              style: AppTextStyles.standard, // Ensure text color contrast
            ),
          ),
          // Buttons aligned to the right
          Row(
            children: [
              CustomButton(
                  onTab: onApprove,
                  text: 'Approve',
                  mainColor: AppColors.primary,
                  horizontalMargin: EdgeInsets.symmetric(
                      horizontal: 8.0)), // Space between buttons
              CustomButton(
                  onTab: onDeny,
                  text: 'Deny',
                  mainColor: AppColors.secondary,
                  horizontalMargin: EdgeInsets.symmetric(horizontal: 8.0)),
            ],
          ),
        ],
      ),
    );
  }
}
