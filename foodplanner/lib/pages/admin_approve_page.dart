import 'package:flutter/material.dart';
import 'package:foodplanner/components/approve_box.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class AdminApprovePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 150.0),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text('Approve Users', style: AppTextStyles.headline1),
                  SizedBox(height: 16.0),
                  Text(
                    'Approve or deny users who want to join your platform',
                    style: AppTextStyles.standard,
                  ),
                  SizedBox(height: 16.0), // Add some spacing before the list
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(20, (index) {
                          return ApproveBox(
                            name: 'User $index',
                            role: index % 2 == 0 ? 'parent' : 'teacher',
                            onApprove: () {
                              // Handle approve action
                            },
                            onDeny: () {
                              // Handle deny action
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
