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
          Center(
            child: SettingsWidget(
              leftIcon: SFIcons.sf_graduationcap_fill,
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
