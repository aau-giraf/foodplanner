
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/navigation/navigation_destination_helper.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/services/active_role_service.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/config/text_styles.dart';
import 'package:provider/provider.dart';

class AdminTeacherNavStrategy extends NavigationStrategy {

  List<String> _pages = [ADMIN_TEACHER_ROOT, CHOOSE_CHILD, SETTINGS_PAGE];

  @override
  set pages(List<String> pages) {
    _pages = pages;
  }

  @override
  List<String> get pages => _pages;

  @override
  void navigate(int index, BuildContext context) async {
    switch(index) {
      case 0|| 1 || 2:
        super.navigate(index, context);
        break;
      case 3: 
        openMenu(context);
        return;
    }
    
    NavigationService.setCurrentPage(index);
  }

  @override
  List<NavigationDestination> getDestinations(UserRoles role){
    return [
      NavigationDestinationHelper.buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
        NavigationDestinationHelper.buildIconDestination(icon: Icons.escalator_warning_outlined, selectedIcon: Icons.escalator_warning, label: ''),
        NavigationDestinationHelper.buildIconDestination(icon: SFIcons.sf_gearshape, label: '', selectedIcon: SFIcons.sf_gearshape_fill, isSfIcon: true),
        NavigationDestinationHelper.buildIconDestination(icon: Icons.room_preferences, selectedIcon: Icons.room_preferences_outlined, label: ''),
    ];
  }

  //alt funktionalitet for case 3 lig den herunder og kald denne funktion under case 3
  void openMenu(BuildContext context){
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
                    Icon(Icons.group),
                    SizedBox(height: 4),
                    Text('Skift rolle', style: AppTextStyles.standardWithoutColor,),
                  ],
                  //(leading: Icon(Icons.home), title: Text('home')),
                ),
              ),
              onTap: () => {
                GoRouter.of(context).go(ADMIN_ROOT),
                ActiveRoleService.setActiveRole(Role.admin),
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
              onTap: () async {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                await authProvider.logout();
                GoRouter.of(context).go(LOGIN_PAGE);
                ActiveRoleService.setActiveRole(null);
              }
            ),
          ],
          elevation: 8.0,
          color: AppColors.background,
          //menuPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        );
  }
}

