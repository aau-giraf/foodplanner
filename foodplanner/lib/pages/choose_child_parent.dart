import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/pages/create_child_page.dart';
import 'package:foodplanner/services/api_config.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/child.dart';
import 'package:foodplanner/services/child_service.dart';

class ChooseChildParent extends StatefulWidget {
  const ChooseChildParent({super.key});

  @override
  State<ChooseChildParent> createState() =>
      ChooseChildParentState();
}

class ChooseChildParentState extends State<ChooseChildParent> {
  final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  dynamic _user;

  final ChildService childService = ChildService(apiUrl: ApiConfig.baseUrl);
  List<Child> children = [];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  // method for retrieving a parents children
  Future<void> _loadChildren() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.loadFromStorage();
      final userData = await userService.fetchLoggedInUser();

      try {
        children = await childService.fetchChildrenByParent();
      } catch (e) {
        print('Could not fetch children: $e');
      }

      if (mounted) { // checks whether the object is part of a tree
        setState(() {
          _user = userData;
        });
      }

    } catch (e) {
      print('Initialization error: $e');
    }
  }

  Widget buildButton(StatefulWidget pageRoute, String buttonTxt, IconData icon, String iconType){
    return CustomButton(
      onTab: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => pageRoute)  
        );
      },
      text: buttonTxt,
      sfIcon: iconType == 'SFicon' ? SFIcon(icon) : null,
      materialIcon: iconType == 'Icon' ? Icon(icon) : null,
      backgroundColor: AppColors.lightSecondary,
      foregroundColor: AppColors.textPrimary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 200,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Text(
            'Vælg barn',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var child in children) 
              ExpansionTile(
                title: Text(child.firstName),
                tilePadding: EdgeInsets.all(15),
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
                children: [
                  Padding(padding: EdgeInsets.all(10)),
                  buildButton(ChooseChildParent(), 'Feedback', SFIcons.sf_message, 'SFIcon'),
                  Padding(padding: EdgeInsets.all(15)),
                  buildButton(ChooseChildParent(), 'Madpakke', Icons.lunch_dining_outlined, 'Icon'),
                  Padding(padding: EdgeInsets.all(15)),
                  buildButton(ChooseChildParent(), 'Indstillinger', Icons.settings_outlined, 'Icon'),
                  Padding(padding: EdgeInsets.all(10)),
                ],
              ),
            buildButton(CreateChildPage(), 'Tilføj barn', Icons.add_reaction_outlined, 'Icon'),
          ],
        ),
      ),
    );
  }
}