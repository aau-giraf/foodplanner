import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/components/add_existing_child.dart';
import 'package:foodplanner/components/button.dart';
import 'package:foodplanner/components/loading_animation.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/pages/signup_page_child.dart';
import 'package:foodplanner/pages/feedback_chat_page.dart';
import 'package:foodplanner/pages/landing_page_parent.dart';
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

  AuthProvider get authProvider => Provider.of<AuthProvider>(context, listen: false);

  final UserService userService = UserService(apiUrl: ApiConfig.baseUrl);
  dynamic _user; 

  final ChildService childService = ChildService(apiUrl: ApiConfig.baseUrl);
  List<Child> children = [];

  bool isLoading = true;

  final singleUseCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  // method for retrieving a parents children
  Future<void> _loadChildren() async {

    setState(() => isLoading = true);

    try {
      await authProvider.loadFromStorage();
      final userData = await userService.fetchLoggedInUser();

      try {
        children = await childService.fetchChildrenByParent();
      } catch (e) {
        print('Could not fetch children: $e');
      }

      await Future.delayed(Duration(milliseconds: 50)); // create a buffer to have enough time for fetchang all children 

      if (mounted) { // checks whether the object is part of a tree
        setState(() {
          _user = userData;
          isLoading = false;
        });
      }

    } catch (e) {
      print('Initialization error: $e');
    }
  }

  Widget buildButton(Widget pageRoute, String buttonTxt, IconData icon, String iconType){
    const double iconSize = 22;
    return CustomButton(
      onTab: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => pageRoute)  
        );
      },
      text: buttonTxt,
      sfIcon: iconType == 'SFIcon' ? SFIcon(icon, fontSize: iconSize) : null,
      materialIcon: iconType == 'Icon' ? Icon(icon, size: iconSize) : null,
      backgroundColor: AppColors.lightSecondary,
      foregroundColor: AppColors.textPrimary,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
                child: LoadingAnimation(
                  imagePath:
                      'assets/images/logo.png', 
                  size: 50.0,
                ));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 200,
        centerTitle: true,
        title: const Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Text(
            'Vælg barn',
            style: TextStyle(fontSize: 36),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: 
          Center(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var child in children) 
                ExpansionTile(
                  title: Text(child.firstName),
                  tilePadding: const EdgeInsets.all(15),
                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(30)),
                  children: [
                    Padding(padding: EdgeInsets.all(10)),
                    Directionality(
                      textDirection: TextDirection.rtl, 
                      child: buildButton(
                        FeedbackChatPage(), // OBS: need to make sure if it is actually the correct one 
                        'Feedback', 
                        SFIcons.sf_message, 
                        'SFIcon'
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Directionality(
                      textDirection: TextDirection.rtl, 
                      child: buildButton(
                        ParentLandingPageMadpakke(), // OBS: need to make sure if this is the correct one
                        'Madpakke', 
                        Icons.lunch_dining_outlined, 
                        'Icon'
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(15)),
                    Directionality(
                      textDirection: TextDirection.rtl, 
                      child: buildButton(
                        ChooseChildParent(), // OBS: this needs to be changed to the correct page
                        'Indstillinger', 
                        Icons.settings_outlined, 
                        'Icon'
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(10)),
                  ],
                ),
              Directionality(
                textDirection: TextDirection.rtl, 
                child: CustomButton(
                  onTab: () async {
                    bool? created = await Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPageChild()));
                    if (created == true) {
                      _loadChildren();
                    }
                  }, 
                  text: 'Tilføj nyt barn', 
                  materialIcon: Icon(Icons.add_reaction_outlined), 
                  backgroundColor: AppColors.lightSecondary,
                  foregroundColor: AppColors.textPrimary,
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                child: AddExistingChild(controller: singleUseCodeController,),
              )
            ],
          ),
        ),
      ),
    );
  }
}