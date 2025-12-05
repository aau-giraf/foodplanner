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
import 'package:foodplanner/components/nav_bar.dart';
import 'package:foodplanner/pages/admin/profiles/admin_one_profile.dart';

class AdminAllProfilesPage extends StatefulWidget {
  static final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  const AdminAllProfilesPage({super.key});

  @override
  _AdminAllProfilesPageState createState() => _AdminAllProfilesPageState();
}

class _AdminAllProfilesPageState extends State<AdminAllProfilesPage> {
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

  // Tror måske den her skal ændres
  void fetchAllUsers() {
    AdminAllProfilesPage.userService.fetchAllUsers().then((result) {
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
    var error = await AdminAllProfilesPage.userService.updateArchived(id);
    
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

  // Tror ikke den her virker
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
        backgroundColor: Colors.white,
        toolbarHeight: 225,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Administrér',
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              Text(
                'profiler',
                style: TextStyle(fontSize: 36),
                textAlign: TextAlign.center,
              ),
              Icon(
                Icons.manage_accounts_outlined,
              ),
              SizedBox(height: 10),
              Text(
                'Alle profiler',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            SearchField(
              controller: searchController,
              hintText: 'Søg efter bruger',
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                color: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filteredUsers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 3),
                        //margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => AdminOneProfilePage(user: user)),
                            );
                          },
                          title: Text(
                            // Evt en bedre måde at vise hvilken rolle de har? Tænker det kan godt være væsentligt rart at have det med
                            '(${user.role}) ${user.firstName} ${user.lastName}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          // if not approve, then vis dette
                          /*trailing: CircleAvatar(
                            radius: 11,
                            backgroundColor: AppColors.primary,
                            child: const Text('!', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          ),*/
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
