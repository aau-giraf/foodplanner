import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/components/settings_header.dart';

class AdministrateChildren extends StatelessWidget {
  const AdministrateChildren({super.key});

  Widget ctaButtons() {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: SFIcon(
            SFIcons.sf_chevron_right,
            color: AppColors.textPrimary,
            fontSize: 28,
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
        leading: IconButton(
          icon: SFIcon(
            SFIcons.sf_chevron_left,
            color: AppColors.textPrimary,
          ),
          onPressed: () {},
        ),
        title: const Text(
          'Indstillinger',
          style: AppTextStyles.headline4,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SettingsHeader(
            icon: SFIcons.sf_figure_and_child_holdinghands,
            title: 'Administrer Børn',
            subtitle: 'Her kan du se og redigere børnenes profiler, skifte deres klasser med mere. ',
          ),
          Center(
            child: SettingsWidget(
              leftIcon: SFIcons.sf_figure_child,
              title: 'John Hansen',
              cta: ctaButtons(),
              type: 'items',
            ),
          ),
          Center(
            child: SettingsWidget(
              leftIcon: SFIcons.sf_figure_child,
              title: 'John Hansen',
              cta: ctaButtons(),
              type: 'items',
            ),
          ),
        ],
      ),
    );
  }
}
