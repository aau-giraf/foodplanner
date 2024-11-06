import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  Widget ctaButtons() {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: SFIcon(
            SFIcons.sf_checkmark_square_fill,
            color: AppColors.primary,
            fontSize: 36,
          ),
          onPressed: () {},
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: SFIcon(
            SFIcons.sf_xmark_square_fill,
            color: AppColors.errorText,
            fontSize: 36,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indstillinger'),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SettingsWidget(
            leftIcon: SFIcons.sf_person_crop_circle_fill_badge_checkmark,
            title: 'Godkend profiler',
            subTitle:
                'Administrer nye profil anmodninger.\nHer kan du godkende eller slette nye brugere.',
            type: SettingsType.header,
          ),
          SettingsWidget(
            leftIcon: SFIcons.sf_00_circle,
            title: "Hey med dig",
            type: SettingsType.items,
            cta: ctaButtons(),
          ),
        ],
      ),
    );
  }
}
