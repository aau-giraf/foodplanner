
import 'package:flutter/material.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';

class TeacherNavStrategy implements NavigationStrategy {
 
  final GlobalKey menuKey = GlobalKey ();

  @override
  void navigate(int index, BuildContext context, ROLES? role) {
    switch(index) {
      case 0:
        GoRouter.of(context).go(TEACHER_ROOT);
        break;
      case 1:
        GoRouter.of(context).go(CHOOSE_CHILD);
        break;                
      case 2:
        GoRouter.of(context).go(SETTINGS_PAGE);
        break;
      case 3: 
        //() async {
        //  final authProvider = Provider.of<AuthProvider>(context, listen: false);
        //  await authProvider.logout();
        //  context.go(LOGIN_PAGE);
        
  
        //final RenderBox renderbox = menuKey.currentContext!.findRenderObject() as Renderbox;
        
        showMenu<String> (
          context: context, 
          position: RelativeRect.fromLTRB(100, 650, 0, 0), 
          items: <PopupMenuItem<String>>[
            PopupMenuItem<String>(
              child: Center( 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.home),
                    SizedBox(height: 4),
                    Text('Home', style: AppTextStyles.standardWithoutColor,),
                  ],
                  //(leading: Icon(Icons.home), title: Text('home')),
                ),
              ),
              onTap: () => {
                GoRouter.of(context).go(TEACHER_ROOT)
              }
            ),

            PopupMenuItem(
              child: Center(
                child: Container(
                  //width: 65,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.5,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: AppColors.textFieldBorderFocus,
                      )
                    )
                  ),
              )
              ),
            ),

            PopupMenuItem(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(height: 4),
                    Text('Log ud', style: AppTextStyles.standardWithoutColor),
                  ],
                ),
              ),
              onTap: () => {
                GoRouter.of(context).go(LOGIN_PAGE)
              }
            ),
          ],
          elevation: 8.0,
          color: AppColors.background,
          //menuPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        );
        
        break;
    }
    
  }

  //alt funktionalitet for case 3 lig den herunder og kald denne funktion under case 3
  void openMenu(){

  }
}

