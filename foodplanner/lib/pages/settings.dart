import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/segment_button.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/pages/administrate_children.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/pages/student_page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsPage();
}

class _SettingsPage extends State<Settings> {
  Set<String> selectedSegment = {'daily'};
  bool notifcations = true;
  bool biometricLogin = true;

  List<ButtonSegment<String>> segments = [
    ButtonSegment(
      value: 'daily',
      label: Text(
        'Dagligt',
        style: AppTextStyles.standardWithoutColor
            .copyWith(fontWeight: FontWeight.bold),
      ),
    ),
    ButtonSegment(
      value: 'weekly',
      label: Text(
        'Ugentligt',
        style: AppTextStyles.standardWithoutColor
            .copyWith(fontWeight: FontWeight.bold),
      ),
    ),
  ];

  List<Map<String, dynamic>> get generalSettings => [
        {
          'title': "Vis madpakke",
          'icon': SFIcons.sf_fork_knife,
          'cta': CustomSegmentButton(
            buttonSegments: segments,
            onTab: segmentChange,
            selected: selectedSegment,
          ),
        },
        {
          'title': "Notifikationer",
          'icon': SFIcons.sf_bell_badge_fill,
          'cta': Switch(
            value: notifcations,
            onChanged: notificationChange,
            trackColor: trackColor,
            overlayColor: overlayColor,
            thumbColor: WidgetStatePropertyAll<Color>(
              Colors.white,
            ),
          ),
        },
        {
          'title': "Biometrisk login",
          'icon': SFIcons.sf_faceid,
          'cta': Switch(
            value: biometricLogin,
            onChanged: biometricChange,
            trackColor: trackColor,
            overlayColor: overlayColor,
            thumbColor: WidgetStatePropertyAll<Color>(
              Colors.white,
            ),
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
          'ctaFunction': () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentPage()),
            );
          }
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
          'ctaFunction': () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdministrateChildren()),
            );
          }
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
        },
      ];

  final WidgetStateProperty<Color?> trackColor =
      WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) {
      // Track color when the switch is selected.
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      // Otherwise return null to set default track color
      // for remaining states such as when the switch is
      // hovered, focused, or disabled.
      return Colors.grey.shade400;
    },
  );

  final WidgetStateProperty<Color?> overlayColor =
      WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) {
      // Material color when switch is selected.
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary.withOpacity(0.54);
      }
      // Material color when switch is disabled.
      if (states.contains(WidgetState.disabled)) {
        return Colors.grey.shade400;
      }
      // Otherwise return null to set default material color
      // for remaining states such as when the switch is
      // hovered, or focused.
      return null;
    },
  );

  void segmentChange(Set<String> value) {
    setState(() {
      selectedSegment = value;
    });
  }

  void notificationChange(bool value) {
    setState(() {
      notifcations = value;
    });
  }

  void biometricChange(bool value) {
    setState(() {
      biometricLogin = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Indstillinger',
          style: AppTextStyles.headline2,
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          ...adminSettings.map((setting) {
                            return SettingsWidget(
                              leftIcon: setting['icon'],
                              title: setting['title'],
                              type: SettingsType.inlineItems,
                              cta: setting['cta'],
                              divider: setting['divider'] ?? true,
                              clickable: true,
                              ctaFunction: setting['ctaFunction'],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
