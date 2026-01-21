import 'package:flutter/material.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/navigation/navigation_service.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/navigation/navbar_strategy_mapper.dart';



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
    
  //final GlobalKey _teacherMenuIconKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthProvider().retrieveRole(),
      //future: _roleFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData) {
          return const SizedBox.shrink();
        }
      
        final UserRoles role = snapshot.data!;
        final index = NavigationService.getCurrentPage();
        final navStrategy = NavBarStrategyMapper.getNavBarStrategy(role);
        final destinations = navStrategy.getDestinations(role);

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
                navStrategy.navigate(index, context);
              },
              destinations: destinations,
            ),
          ),
        );
      },
    );
  }
}