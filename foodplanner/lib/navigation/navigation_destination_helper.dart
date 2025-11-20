import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';


class NavigationDestinationHelper {

  static NavigationDestination buildDestination({
    required Widget icon,
    required Widget selectedIcon,
    required String label,
  }) {
    return NavigationDestination(
      icon: icon, 
      selectedIcon: selectedIcon, 
      label: label
    );
  }

  static NavigationDestination buildIconDestination({
    required dynamic icon,
    required dynamic selectedIcon,
    required String label,
    bool isSfIcon = false,
  }) {
    final Widget normalIcon = isSfIcon 
      ? SFIcon(icon) 
      : Icon(icon);

    final Widget filledIcon = isSfIcon 
        ? SFIcon(selectedIcon, color: Colors.white)
        : Icon(selectedIcon, color: Colors.white);
    
    return buildDestination(
      icon: normalIcon, 
      selectedIcon: filledIcon, 
      label: label,
    ); 
  }
/*
  static List<NavigationDestination> adminRoleDestination() {
    return [
      _buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      _buildIconDestination(icon: Icons.manage_accounts_outlined, selectedIcon: Icons.manage_accounts, label: ''),
      _buildIconDestination(icon: Icons.school_outlined, selectedIcon: Icons.school, label: ''),
      _buildIconDestination(icon: SFIcons.sf_gearshape, selectedIcon: SFIcons.sf_gearshape_fill, label: '', isSfIcon: true),
      _buildIconDestination(icon: Icons.room_preferences_outlined, selectedIcon: Icons.room_preferences, label: ''),
    ];
  }

  static List<NavigationDestination> teacherRoleDestination() {
    return [
      _buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      _buildIconDestination(icon: Icons.escalator_warning_outlined, selectedIcon: Icons.escalator_warning, label: ''),
      _buildIconDestination(icon: SFIcons.sf_gearshape, selectedIcon: SFIcons.sf_gearshape_fill, label: '', isSfIcon: true),
      _buildIconDestination(icon: Icons.room_preferences_outlined, selectedIcon: Icons.room_preferences, label: ''),
    ];
  }
  */
}
