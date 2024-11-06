import 'package:flutter/material.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';

class AdminApprovePage extends StatefulWidget {
  const AdminApprovePage({super.key});
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  @override
  State<AdminApprovePage> createState() => _AdminApprovePageState();
}

class _AdminApprovePageState extends State<AdminApprovePage> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Function to load users asynchronously
  Future<void> _loadUsers() async {
    final users = await AdminApprovePage.userService.fetchApproveUsers();
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Indstillinger',
              style:
                  AppTextStyles.standard.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        centerTitle: false,
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Content goes here',
          style: AppTextStyles.standard,
        ),
      ),
    );
  }
}
