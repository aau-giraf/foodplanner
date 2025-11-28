import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/components/popup_box.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/services/user_service.dart';

class AdminOneProfilePage extends StatefulWidget {
  const AdminOneProfilePage({super.key});
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);

  @override
  State<AdminOneProfilePage> createState() => _AdminOneProfilePageState();
}

class _AdminOneProfilePageState extends State<AdminOneProfilePage> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
              SizedBox(height: 35),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        // Popup med ting der skal fikses, fx: "Bob Olsen anmoder om tilknytning til Georg Olsen"
        // Nuværende rolle: {UserRoles}
        // Tilknytning: {barn}
        // Tildel / fjern administrator rolle
        // Slet profil
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
                  ],
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