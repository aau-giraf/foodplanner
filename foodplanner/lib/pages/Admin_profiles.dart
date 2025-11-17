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

class AdminProfilesPage extends StatelessWidget {
  const AdminProfilesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
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
      ),*/
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
          children: [
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
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CustomButton(
                onTab: null,
                text: "Alle profiler",
                foregroundColor: AppColors.textPrimary,
                backgroundColor: AppColors.background,
                size: ButtonSize.medium,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}