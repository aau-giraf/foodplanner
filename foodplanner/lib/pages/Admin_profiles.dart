import 'package:flutter/material.dart';
import 'package:foodplanner/components/button.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/Admin_profiles.dart';
import 'package:foodplanner/pages/settings/deactivate_accounts.dart'; 
import 'package:foodplanner/pages/settings/admin_approve_page.dart'; 
import 'package:go_router/go_router.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/models/user.dart';

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

  // Function to load users asynchronously
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
                'Administrér profiler',
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              Text(
                  'Aktive anmodninger',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: AppColors.primary, // Din orange
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '2',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10),
              ..._users.asMap().entries.map((entry) {
                final index = entry.key;
                final user  = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: SettingsWidget(
                    title: "${user.firstName} ${user.lastName}",
                    type: SettingsType.inlineItems,
                    cta: IconButton(
                      icon: const SFIcon(
                        SFIcons.sf_checkmark_circle_fill,
                      ),
                      onPressed: () async {
                        setState(() {
                          _users.removeAt(index);
                        });
                      },
                    ),
                    clickable: true,
                    ctaFunction: () async {
                      setState(() {
                        _users.removeAt(index);
                      });
                    },
                  ),
                );
              }).toList(),
            Card(
              elevation: 2,
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    ColoredBox(
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 10),
                    /*SettingsWidget(
                      leftIcon: SFIcons.sf_person_crop_circle_fill_badge_checkmark,
                      title: 'Godkend profiler',
                      subTitle: 'Gå til godkendelse af nye profiler',
                      type: SettingsType.inlineItems,
                      cta: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SFIcon(SFIcons.sf_chevron_forward),
                          SizedBox(width: 10),
                        ],
                      ),
                      clickable: true,
                      ctaFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminApprovePage()),
                        );
                      },
                    ),*/
                    /*SettingsWidget(
                      leftIcon: SFIcons.sf_person_fill_badge_minus,
                      title: 'Deaktiver profiler',
                      subTitle: 'Gå til deaktivering af profiler',
                      type: SettingsType.inlineItems,
                      cta: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SFIcon(SFIcons.sf_chevron_forward),
                          SizedBox(width: 10),
                        ],
                      ),
                      clickable: true,
                      ctaFunction: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminAllProfiles()),
                        );
                      },
                    ),*/
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomButton(
                        onTab: null,
                        text: "{konto_navn}",
                        foregroundColor: AppColors.textPrimary,
                        backgroundColor: AppColors.background,
                        size: ButtonSize.medium,
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.primary, // Din orange
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
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
                    MaterialPageRoute(builder: (context) => const AdminAllProfiles()),
                  );
                },
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,                         // hvid som i Figma
                    borderRadius: BorderRadius.circular(50),     // pill-form
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),   // let skygge
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
      bottomNavigationBar: NavBar(),
    );
  }
}