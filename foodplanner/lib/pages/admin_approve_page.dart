import 'package:flutter/material.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:flutter_sficon/flutter_sficon.dart';

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
    try {
      final users = await AdminApprovePage.userService.fetchApproveUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
      print('Users loaded: ${_users.length}');
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to remove a user after approval or denial
  void _approveUser(int userId) async {
    try {
      final bool success =
          await AdminApprovePage.userService.updateApproveUsers(userId);
      if (success) {
        final List<User> updatedUsers =
            await AdminApprovePage.userService.fetchApproveUsers();
        setState(() {
          _users = updatedUsers;
        });
      }
    } catch (e) {
      print('Error approving user: $e');
    }
  }

// Function to remove a user
  void _removeUser(int userId) async {
    try {
      final bool success =
          await AdminApprovePage.userService.unapproveUsers(userId);
      if (success) {
        final List<User> updatedUsers =
            await AdminApprovePage.userService.fetchApproveUsers();
        setState(() {
          _users = updatedUsers;
        });
      }
    } catch (e) {
      print('Error removing user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Indstillinger',
          style: AppTextStyles.standard.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SettingsWidget(
                  leftIcon: SFIcons.sf_person_crop_circle_fill_badge_checkmark,
                  title: 'Godkend profiler',
                  subTitle:
                      'Administrer nye profil anmodninger.\nHer kan du godkende eller slette nye brugere.',
                  type: SettingsType.header,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [
                          0.0,
                          0.95,
                          1.0
                        ], // Adjust the stops to create a slow-to-fast fade effect
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return SettingsWidget(
                          leftIcon: user.role == 'teacher'
                              ? SFIcons.sf_graduationcap_fill
                              : SFIcons.sf_figure_and_child_holdinghands,
                          title: "${user.firstName} ${user.lastName}",
                          subTitle: user.email,
                          type: SettingsType.items,
                          cta: Row(
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: SFIcon(
                                  SFIcons.sf_checkmark_square_fill,
                                  color: AppColors.primary,
                                  fontSize: 36,
                                ),
                                onPressed: () {
                                  _approveUser(user.id);
                                },
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: SFIcon(
                                  SFIcons.sf_xmark_square_fill,
                                  color: AppColors.errorText,
                                  fontSize: 36,
                                ),
                                onPressed: () {
                                  _removeUser(user.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
