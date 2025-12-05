import 'dart:developer' as developer;

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

class DeactivateAccountsPage extends StatefulWidget {
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  const DeactivateAccountsPage({super.key});

  @override
  _DeactivateAccountsPageState createState() => _DeactivateAccountsPageState();
}

class _DeactivateAccountsPageState extends State<DeactivateAccountsPage> {
  bool isSwitched = true;
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
    
    if (!mounted){
      developer.log('buildcontext is not mounted, in $runtimeType');
      return;
    }

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

  void showPopup(bool isActive, User user, int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return IPhonePopupBox(
          title: isActive
              ? 'Er du sikker på at du vil genaktivere brugeren'
              : 'Er du sikker på at du vil deaktivere brugeren',
          confirmText: 'Ja',
          cancelText: 'Nej',
          onConfirm: () {
            Navigator.of(context).pop();
            setState(() {
              controllers[userId] = isActive;
            });
            updateArchived(user.id);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
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
            SizedBox(
              height: 20,
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
                  cta: Stack(
                    children: [
                      AdvancedSwitch(
                        activeColor: AppColors.primary,
                        width: 60,
                        initialValue: controllers[user.id]!,
                        onChanged: (value) {
                          // Do nothing here
                        },
                      ),
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            showPopup(!controllers[user.id]!, user, user.id);
                          },
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
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
