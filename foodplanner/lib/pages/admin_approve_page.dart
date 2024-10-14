import 'package:flutter/material.dart';
import 'package:foodplanner/components/approve_box.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/components/user.dart';

class AdminApprovePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text('Godkend Nye Brugere', style: AppTextStyles.headline1),
                  SizedBox(height: 16.0),
                  Text(
                    'Godkend eller afvis brugere som gerne vil tilgå din platform',
                    style: AppTextStyles.standard,
                  ),
                  SizedBox(height: 16.0), // Add some spacing before the list
                  Expanded(
                    child: FutureBuilder<List<User>>(
                      future: fetchApproveUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                              child: Text('Ingen nye bugere til godkendelse.'));
                        } else {
                          final users = snapshot.data!;
                          return SingleChildScrollView(
                            child: Column(
                              children: users.map((user) {
                                return ApproveBox(
                                  name: user.firstName,
                                  role: user.role,
                                  onApprove: () async {
                                    await updateApproveUsers(user.id);
                                  },
                                  onDeny: () async {
                                    await unapproveUsers(user.id);
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
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
