import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/admin/profiles/admin_profiles.dart';
import 'package:foodplanner/pages/admin/profiles/admin_all_profiles.dart'; 
import 'package:foodplanner/pages/admin/profiles/admin_approve_page.dart'; 
import 'package:go_router/go_router.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/pages/admin/profiles/admin_one_profile.dart';
import 'package:foodplanner/pages/admin/profiles/deactivate_accounts.dart';
import 'package:foodplanner/components/popup_box.dart';

class AdminProfilesPage extends StatefulWidget {
  const AdminProfilesPage({super.key});
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  State<AdminProfilesPage> createState() => _AdminProfilesPageState();
}

class _AdminProfilesPageState extends State<AdminProfilesPage> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await AdminProfilesPage.userService.fetchApproveUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
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
      //final messenger = ScaffoldMessenger.of(context);
      final bool success =
          await AdminProfilesPage.userService.updateApproveUsers(userId);
      if (success) {
        final List<User> updatedUsers =
            await AdminProfilesPage.userService.fetchApproveUsers();
        setState(() {
          _users = updatedUsers;
        });
      }
    } catch (e) {
      print('Error approving user: $e');
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Brugeren er blevet godkendt'),
        backgroundColor: Colors.green,
      ),
    );
  }

// Function to remove a user
  void _removeUser(int userId) async {
    try {
      final bool success =
          await AdminProfilesPage.userService.unapproveUsers(userId);
      if (success) {
        final List<User> updatedUsers =
            await AdminProfilesPage.userService.fetchApproveUsers();
        setState(() {
          _users = updatedUsers;
        });
      }
    } catch (e) {
      print('Error removing user: $e');
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Brugeren er blevet fjernet'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 225,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Administrér',
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              Text(
                'profiler',
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              Icon(
                Icons.manage_accounts_outlined,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Aktive anmodninger',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center (
                      child: Text(
                        '${_users.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    )
                  )
                ]
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  color: AppColors.background,
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 3,
                      bottom: 3,
                      left: 5,
                      right: 5,
                    ),
                    child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _users.isEmpty
                    ? const Center(child: Text('Ingen anmodninger lige nu'))
                    : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _users.length,
                      separatorBuilder: (_, __) =>
                        const SizedBox(height: 0),
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => AdminOneProfilePage(/* user.id */),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${user.firstName} ${user.lastName}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '!',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminAllProfilesPage()),
                    );
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Alle profiler',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SFIcon(SFIcons.sf_chevron_forward),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(),
      /*body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Card(
              elevation: 2,
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10
                ),
                child: Column(
                  children: [
                    ..._users.asMap().entries.map((entry) {
                      final index = entry.key;
                      final user = entry.value;
                      return Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        clipBehavior: Clip.antiAlias,
                        child: SettingsWidget(
                          title: '${user.firstName} ${user.lastName}', 
                          type: SettingsType.inlineItems,
                          divider: false,
                          clickable: true,
                          ctaFunction: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (c) => AdminOneProfilePage(/*${user.id}*/)));
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminAllProfilesPage()),
                  );
                },
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Alle profiler',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SFIcon(SFIcons.sf_chevron_forward),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),*/
    );
  }
}