import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/services/navbar_factory_service.dart';
import 'package:go_router/go_router.dart';
//import 'package:flutter/foundation.dart';


class NavBar extends StatefulWidget {
  int currentPageIndex;
  
  NavBar({
    super.key,
    this.currentPageIndex = 0,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  //final List<Widget> _destinations = [];

  //final Future<ROLES?> _roleFuture = AuthProvider().retrieveRole();

  void _handleNavigation(int index, ROLES role, BuildContext context) {
    //setState((){
    //  widget.currentPageIndex = index;
    //});

    if(role == ROLES.teacher || role == ROLES.guardian) {
      switch(index) {
        case 0:
          if(role == ROLES.guardian){
          GoRouter.of(context).go(PARENT_ROOT);
          break;
          } else {
            GoRouter.of(context).go(TEACHER_ROOT);
          break;
          }

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
          GoRouter.of(context).go(LOGIN_PAGE);
          break;
      }
    } else if (role == ROLES.student){
      switch(index) {
        case 0: 
          GoRouter.of(context).go(FEEDBACK_Page);
          break;
        case 1: 
          GoRouter.of(context).go(MADPAKKE);
          break;
        case 2:
          GoRouter.of(context).go(SETTINGS_PAGE);
          break;
      }
    } else if (role == ROLES.admin) {
        switch(index) {
          case 0:
            GoRouter.of(context).go(ADMIN_ROOT);
            break;
          case 1:
            GoRouter.of(context).go(SETTINGS_PAGE);
            break;
          case 2:
            GoRouter.of(context).go(LOGIN_PAGE);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthProvider().retrieveRole(),
      //future: _roleFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData) {
          return const SizedBox.shrink();
      }
      final role = snapshot.data!;
      final index = widget.currentPageIndex;
      final destinations = NavBarDestinationFactory.getNavBarDestinations(role);

      //final bool onStartPage = isStartPage(context);
      //final safeIndex =  widget.currentPageIndex; //.clamp(0, destinations.length -1);
      //final safeIndex =  widget.currentPageIndex;
      //debugPrint('Destinations: ${destinations.map((d) => d.label).toList()}');
      //debugPrint('SelectedIndex: ${index}');

      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
          child: NavigationBar(
            backgroundColor: AppColors.background,
            indicatorColor: AppColors.primary,
            selectedIndex: index,
            //debugPrint('index widget: ${widget.currentPageIndex}'),
            onDestinationSelected: (int index) => {
              //debugPrint('Nav pressed index: $index'),
              setState(() {
                widget.currentPageIndex = index;
              }),
              //debugPrint('index widget: ${widget.currentPageIndex}'),
              _handleNavigation(index, role, context),
            },
            destinations: destinations,
          )
        );
  },);
  }
}










/*
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatefulWidget {
  int currentPageIndex;
  NavBar({super.key, this.currentPageIndex = 1});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<Widget> _destinations = [
    NavigationDestination(
      selectedIcon: SFIcon(
        SFIcons.sf_message_fill,
        color: Colors.white,
      ),
      icon: SFIcon(SFIcons.sf_message),
      label: 'Feedback',
    ),
    NavigationDestination(
      selectedIcon: SFIcon(
        SFIcons.sf_gift_fill,
        color: Colors.white,
      ),
      icon: SFIcon(SFIcons.sf_gift),
      label: 'Madpakke',
    ),
    NavigationDestination(
      selectedIcon: SFIcon(
        SFIcons.sf_person_fill,
        color: Colors.white,
      ),
      icon: SFIcon(SFIcons.sf_person),
      label: 'Profil',
    ),
    NavigationDestination(
      selectedIcon: SFIcon(
        SFIcons.sf_gearshape_fill,
        color: Colors.white,
      ),
      icon: SFIcon(SFIcons.sf_gearshape),
      label: 'Indstillinger',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthProvider().retrieveRole(),
      builder: (context, snapshot) => snapshot.hasData
          ? ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              child: NavigationBar(
                backgroundColor: AppColors.background,
                onDestinationSelected: (int index) {
                  setState(() {
                    widget.currentPageIndex = index;
                  });
                  switch (index) {
                    case 0:
                      if (snapshot.data != ROLES.teacher) {
                        GoRouter.of(context).go('/feedback');
                        break;
                      } else {
                        GoRouter.of(context).go('/');
                        break;
                      }
                    case 1:
                      if (snapshot.data != ROLES.teacher) {
                        GoRouter.of(context).go('/');
                        break;
                      } else {
                        GoRouter.of(context).go('/profile');
                        break;
                      }
                    case 2:
                      if (snapshot.data != ROLES.teacher) {
                        GoRouter.of(context).go('/profile');
                        break;
                      } else {
                        GoRouter.of(context).go('/settings');
                        break;
                      }
                    case 3:
                      GoRouter.of(context).go('/settings');
                      break;
                  }
                },
                indicatorColor: AppColors.primary,
                selectedIndex: snapshot.data != ROLES.teacher
                    ? widget
                        .currentPageIndex // If user not teacher use as normal
                    : widget.currentPageIndex ==
                            0 // If user is teacher and on first page
                        ? widget
                            .currentPageIndex // then we want to stay on first page
                        : widget.currentPageIndex -
                            1, // else we want to shift the index to account for the missing page
                destinations: snapshot.data != ROLES.teacher
                    ? _destinations
                    : _destinations.sublist(1), // Remove the first page
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
*/