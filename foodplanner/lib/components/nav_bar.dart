import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/navigation/admin_nav_strategy.dart';
import 'package:foodplanner/navigation/guardian_nav_strategy.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/navigation/navigation_strategy.dart';
import 'package:foodplanner/navigation/student_nav_strategy.dart';
import 'package:foodplanner/navigation/teacher_nav_strategy.dart';
import 'package:foodplanner/pages/landing_page_teacher.dart';
import 'package:foodplanner/routes/paths.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/navigation/navbar_strategy_mapper.dart';
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
    
  final GlobalKey _teacherMenuIconKey = GlobalKey();

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
        final index = NavigationService.getCurrentPage();
        final navStrategy = NavBarStrategyMapper.getNavBarStrategy(role);
        final destinations = navStrategy.getDestinations();

        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: NavigationBarTheme(
            data: const NavigationBarThemeData(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            ),
            child: NavigationBar(
              backgroundColor: AppColors.background,
              indicatorColor: AppColors.primary,
              selectedIndex: index,
              onDestinationSelected: (int index) {
                setState(() {
                  widget.currentPageIndex = index;
                });
                navStrategy.navigate(index, context, role);
              },
              destinations: destinations,
            ),
          ),
        );
      },
    );
  }
}










/*
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/routes/user_roles.dart';

import 'package:foodplanner/models/user_roles.dart';

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
                      if (snapshot.data?.hasRole(Role.teacher) ?? false) {
                        GoRouter.of(context).go('/feedback');
                        break;
                      } else {
                        GoRouter.of(context).go('/');
                        break;
                      }
                    case 1:
                      if (snapshot.data?.hasRole(Role.teacher) ?? false) {
                        GoRouter.of(context).go('/');
                        break;
                      } else {
                        GoRouter.of(context).go('/profile');
                        break;
                      }
                    case 2:
                      if (snapshot.data?.hasRole(Role.parent) ?? false) {
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
                selectedIndex: (snapshot.data?.hasRole(Role.teacher) ?? false)
                    ? widget
                        .currentPageIndex // If user not teacher use as normal
                    : widget.currentPageIndex ==
                            0 // If user is teacher and on first page
                        ? widget
                            .currentPageIndex // then we want to stay on first page
                        : widget.currentPageIndex -
                            1, // else we want to shift the index to account for the missing page
                destinations: (snapshot.data?.hasRole(Role.teacher) ?? false)
                    ? _destinations
                    : _destinations.sublist(1), // Remove the first page
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
*/