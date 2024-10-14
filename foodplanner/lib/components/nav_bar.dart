import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:foodplanner/pages/additional_lunch_box.dart';
import 'package:foodplanner/pages/lunch_box.dart';
import 'package:foodplanner/pages/profile.dart';
import 'package:foodplanner/pages/settings.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: NavigationBar(
          backgroundColor: Colors.white,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: AppColors.primary,
          selectedIndex: currentPageIndex,
          destinations: [
            NavigationDestination(
              selectedIcon: SFIcon(
                SFIcons.sf_shippingbox_fill,
                color: Colors.white,
              ),
              icon: SFIcon(SFIcons.sf_shippingbox),
              label: 'Ekstra madpakke',
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
          ],
        ),
      ),
      body: [
        AdditionalLunchBox(),
        LunchBox(),
        Profile(),
        Settings()
      ][currentPageIndex],
    );
  }
}
