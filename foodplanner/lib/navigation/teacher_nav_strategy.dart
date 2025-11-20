
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/navigation/navigation_destination_helper.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:provider/provider.dart';

class TeacherNavStrategy extends NavigationStrategy {
 
  final GlobalKey menuKey = GlobalKey ();

  List<String> _pages = [TEACHER_ROOT, CHOOSE_CHILD, SETTINGS_PAGE, LOGIN_PAGE];

  @override
  set pages(List<String> pages) {
    _pages = pages;
  }

  @override
  List<String> get pages => _pages;

  @override
  void navigate(int index, BuildContext context, UserRoles role) async {
    switch(index) {
      case 0|| 1 || 2:
        super.navigate(index, context, role);
        break;
      case 3: 

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.logout();
        context.go(LOGIN_PAGE);
        

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
    
    NavigationService.setCurrentPage(index);
  }

  @override
  List<NavigationDestination> getDestinations(){
    return [
      NavigationDestinationHelper.buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.escalator_warning_outlined, selectedIcon: Icons.escalator_warning, label: ''),
      NavigationDestinationHelper.buildIconDestination(icon: SFIcons.sf_gearshape, label: '', selectedIcon: SFIcons.sf_gearshape_fill, isSfIcon: true),
      NavigationDestinationHelper.buildIconDestination(icon: Icons.logout_outlined, selectedIcon: Icons.logout_outlined, label: ''),
    ];
  }

  //alt funktionalitet for case 3 lig den herunder og kald denne funktion under case 3
  void openMenu(){

  }
}

