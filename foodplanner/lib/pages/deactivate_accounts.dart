import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/search_field.dart';
import 'package:foodplanner/components/settings_widget.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';

class DeactivateAccountsPage extends StatefulWidget {
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  const DeactivateAccountsPage({super.key});

  @override
  _DeactivateAccountsPageState createState() => _DeactivateAccountsPageState();
}

class _DeactivateAccountsPageState extends State<DeactivateAccountsPage> {
  bool isSwitched = true;
  /* Future<List<User>> futureUsers =
      DeactivateAccountsPage.userService.fetchAllUsers(); */
  TextEditingController searchController = TextEditingController();

  List<User> users = [];
  List<User> filteredUsers = [];

  Map<int, bool> controllers = {};

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
    searchController.addListener(filterUsers);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void fetchAllUsers() {
    DeactivateAccountsPage.userService.fetchAllUsers().then((result) {
      setState(() {
        users = result;
        filteredUsers = result;
        for (var user in filteredUsers) {
          controllers[user.id] = (!user.archived);
        }
      });
    });
  }

  void updateArchived(int id) async {
    var error = await DeactivateAccountsPage.userService.updateArchived(id);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error['Message'][0]),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.errorText,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Brugeren er blevet opdateret'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void filterUsers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        final name = '${user.firstName} ${user.lastName}'.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                SFIcon(SFIcons.sf_chevron_backward),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Indstillinger',
                  style: AppTextStyles.headline4,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
        leadingWidth: 200,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsWidget(
              leftIcon: SFIcons.sf_person_crop_circle_fill_badge_minus,
              title: 'Deaktiver profiler',
              subTitle:
                  'Administrer profiler. Her kan du deaktivere eller genaktivere brugere.',
              type: SettingsType.header,
            ),
            SearchField(
              controller: searchController,
              hintText: 'Søg efter bruger',
            ),
            ...filteredUsers.map(
              (user) {
                return SettingsWidget(
                  title: '${user.firstName} ${user.lastName}',
                  type: SettingsType.items,
                  leftIcon: user.role == 'Teacher'
                      ? SFIcons.sf_graduationcap_fill
                      : SFIcons.sf_figure_and_child_holdinghands,
                  cta: AdvancedSwitch(
                    //controller: controllers[user.id],
                    activeColor: AppColors.primary,
                    width: 60,
                    initialValue: controllers[user.id]!,
                    onChanged: (value) {
                      setState(() {
                        controllers[user.id] = !controllers[user.id]!;
                      });
                      updateArchived(user.id);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
