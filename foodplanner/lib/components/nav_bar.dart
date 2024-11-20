import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/config/colors.dart';
import 'package:go_router/go_router.dart';

class NavBar extends StatefulWidget {
  int currentPageIndex;
  NavBar({super.key, this.currentPageIndex = 1});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
              GoRouter.of(context).go('/feedback');
              break;
            case 1:
              GoRouter.of(context).go('/');
              break;
            case 2:
              GoRouter.of(context).go('/profile');
              break;
            case 3:
              GoRouter.of(context).go('/settings');
              break;
          }
        },
        indicatorColor: AppColors.primary,
        selectedIndex: widget.currentPageIndex,
        destinations: [
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
        ],
      ),
    );
  }
}
