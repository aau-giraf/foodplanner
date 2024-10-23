import 'package:flutter/material.dart';
import 'package:foodplanner/components/approve_box.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/components/user.dart';

class AdminApprovePage extends StatefulWidget {
  @override
  _AdminApprovePageState createState() => _AdminApprovePageState();
}

class _AdminApprovePageState extends State<AdminApprovePage> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Function to load users asynchronously
  Future<void> _loadUsers() async {
    final users = await fetchApproveUsers();
    setState(() {
      _users = users;
    });
  }

  // Function to remove a user after approval or denial
  void _removeUser(int userId) {
    setState(() {
      _users.removeWhere((user) => user.id == userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Godkend nye brugere',
          style: AppTextStyles.title,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Godkend eller afvis brugere som gerne vil tilgå din platform',
                    style: AppTextStyles.standard,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),

                  // Expanded widget for the list of users
                  Expanded(
                    child: _users.isEmpty
                        ? Center(
                            child: Text('Ingen nye bugere til godkendelse.'),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: _users.map((user) {
                                return ApproveBox(
                                  name: user.firstName,
                                  LastName: user.lastName,
                                  role: user.role,
                                  onApprove: () async {
                                    await updateApproveUsers(user.id);
                                    _removeUser(user
                                        .id); // Remove the user from the list
                                  },
                                  onDeny: () async {
                                    await unapproveUsers(user.id);
                                    _removeUser(user
                                        .id); // Remove the user from the list
                                  },
                                );
                              }).toList(),
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
