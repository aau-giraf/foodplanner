import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';

class  DeactivateAccountsPage extends StatefulWidget {
  const  DeactivateAccountsPage({super.key});

  @override 
  _DeactivateAccountsPageState createState() => _DeactivateAccountsPageState();

}

class _DeactivateAccountsPageState extends State<DeactivateAccountsPage> {
  bool isSwitched = true;

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
            leftIcon: SFIcons.sf_person_crop_circle_fill_badge_minus,
            title: 'Deaktiver profiler',
            subTitle:
                'Administrer profiler. Her kan du deaktivere eller genaktivere brugere.',
            type: SettingsType.header,
          ),
          SettingsWidget(
            leftIcon: SFIcons.sf_00_circle,
            title: "John",
            type: SettingsType.items,
            cta: Container(
              child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
                activeColor: const Color.fromARGB(255, 255, 255, 255),
                inactiveThumbColor: Color.fromARGB(255, 255, 255, 255),
                inactiveTrackColor: Color.fromRGBO(222, 222, 223, 100),
                activeTrackColor: AppColors.primary
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}
