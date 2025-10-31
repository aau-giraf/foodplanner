import 'package:flutter/material.dart';

import 'package:foodplanner/auth/auth_provider.dart';



import 'package:foodplanner/services/api_config.dart';

import 'package:foodplanner/services/user_service.dart';

import 'package:provider/provider.dart';

class ParentMainPage extends StatefulWidget {
  const ParentMainPage({super.key});

  @override
  State<ParentMainPage> createState() =>
      ParentMainPageState();
}

class ParentMainPageState extends State<ParentMainPage> {
  final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  dynamic _user;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadFromStorage().then((_) {
      authProvider.retrieveToken().then((token) {
        userService.fetchLoggedInUser().then((userData) {
          setState(() {
            _user = userData;
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold();

  }



}