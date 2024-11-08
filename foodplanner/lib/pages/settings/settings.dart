import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_advanced_segment/flutter_advanced_segment.dart';
import 'package:foodplanner/pages/settings/SchoolClasses.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsPage();
}

class _SettingsPage extends State<Settings> {
  Set<String> selectedSegment = {'daily'};
  bool notifications = true;
  bool biometricLogin = true;
  final showLunchBoxController = ValueNotifier<String>('daily');
  final notificationsController = ValueNotifier<bool>(true);
  final biometricLoginController = ValueNotifier<bool>(true);

  List<Map<String, dynamic>> get generalSettings => [
        {
          'title': "Vis madpakke",
          'icon': SFIcons.sf_fork_knife,
          'cta': AdvancedSegment(
              controller: showLunchBoxController,
              segments: {'daily': 'Dagligt', 'weekly': "Ugentligt"},
              activeStyle: AppTextStyles.standard.copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              inactiveStyle: AppTextStyles.standardWithoutColor
                  .copyWith(fontWeight: FontWeight.bold),
              itemPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              sliderColor: AppColors.primary,
              sliderOffset: 0,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              backgroundColor: AppColors.lightSecondary),
        },
        {
          'title': "Notifikationer",
          'icon': SFIcons.sf_bell_badge_fill,
          'cta': AdvancedSwitch(
            controller: notificationsController,
            activeColor: AppColors.primary,
            width: 60,
            initialValue: true,
          )
        },
        {
          'title': "Biometrisk login",
          'icon': SFIcons.sf_faceid,
          'cta': AdvancedSwitch(
            controller: biometricLoginController,
            activeColor: AppColors.primary,
            width: 60,
            initialValue: true,
          ),
          'divider': false,
        },
      ];

  List<Map<String, dynamic>> get adminSettings => [
        {
          'title': "Godkend profiler",
          'icon': SFIcons.sf_person_crop_circle_badge_checkmark,
          'cta': Row(
            children: [
              (SFIcon(SFIcons.sf_chevron_forward)),
              SizedBox(width: 10),
            ],
          )
        },
        {
          'title': "Deaktiver profiler",
          'icon': SFIcons.sf_person_crop_circle_badge_minus,
          'cta': Row(
            children: [
              SFIcon(SFIcons.sf_chevron_forward),
              SizedBox(
                width: 10,
              )
            ],
          ),
        },
        {
          'title': "Administrer børn",
          'icon': SFIcons.sf_figure_and_child_holdinghands,
          'cta': Row(
            children: [
              SFIcon(SFIcons.sf_chevron_forward),
              SizedBox(width: 10),
            ],
          ),
        },
        {
          'title': "Administrer klasser",
          'icon': SFIcons.sf_figure_2,
          'cta': Row(
            children: [
              SFIcon(SFIcons.sf_chevron_forward),
              SizedBox(width: 10),
            ],
          ),
          'divider': false,
          'ctaFunction': () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SchoolClasses()),
            );
          }
        },
      ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Indstillinger',
          style: AppTextStyles.headline2,
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 2,
                color: AppColors.background,
                surfaceTintColor: AppColors.background,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          "Generelt",
                          style: AppTextStyles.bigText.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ...generalSettings.map((setting) {
                          return SettingsWidget(
                            leftIcon: setting['icon'],
                            title: setting['title'],
                            type: SettingsType.inlineItems,
                            cta: setting['cta'],
                            divider: setting['divider'] ?? true,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              if (authProvider.hasRole(ROLES.admin))
                Card(
                  elevation: 2,
                  color: AppColors.background,
                  surfaceTintColor: AppColors.background,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            "Admin",
                            style: AppTextStyles.bigText.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          ...adminSettings.map(
                            (setting) {
                              return SettingsWidget(
                                leftIcon: setting['icon'],
                                title: setting['title'],
                                type: SettingsType.inlineItems,
                                cta: setting['cta'],
                                divider: setting['divider'] ?? true,
                                clickable: true,
                                ctaFunction: setting['ctaFunction'],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomButton(
                  onTab: null,
                  text: "Slet konto",
                  foregroundColor: AppColors.errorText,
                  backgroundColor: AppColors.background,
                  size: ButtonSize.medium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
