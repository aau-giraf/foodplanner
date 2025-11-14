import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/Admin_profiles.dart';
import 'package:foodplanner/pages/settings/deactivate_accounts.dart'; 
import 'package:foodplanner/pages/settings/admin_approve_page.dart'; 
import 'package:go_router/go_router.dart';

class AdminProfilesPage extends StatelessWidget {
  const AdminProfilesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 225,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Text(
            'Administrér profiler',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          ),
        )
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              child: Text(
                'Aktive anmodninger',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            Card(
              elevation: 2,
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    SettingsWidget(
                      title: 'title',
                      type: SettingsType.inlineItems,
                    ),
                    SettingsWidget(
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
                    ),
                    SettingsWidget(
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
                          MaterialPageRoute(builder: (context) => const DeactivateAccountsPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}