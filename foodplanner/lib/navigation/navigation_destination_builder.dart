import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';

class NavigationDestinationBuilder {


  static NavigationDestination _buildDestination({
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

  static NavigationDestination _buildIconDestination({
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
    
    return _buildDestination(
      icon: normalIcon, 
      selectedIcon: filledIcon, 
      label: label,
    ); 
  }

  static List<NavigationDestination> teacherDestinations() {
    return [
      _buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      _buildIconDestination(icon: Icons.escalator_warning_outlined, selectedIcon: Icons.escalator_warning, label: ''),
      _buildIconDestination(icon: SFIcons.sf_gearshape, label: '',selectedIcon: SFIcons.sf_gearshape_fill, isSfIcon: true),
      _buildIconDestination(icon: Icons.logout_outlined, selectedIcon: Icons.logout_outlined, label: ''),
    ];
  }

  static List<NavigationDestination> guardianDestinations() {
    return [
      _buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      _buildIconDestination(icon: Icons.escalator_warning_outlined, selectedIcon: Icons.escalator_warning, label: ''),
      _buildIconDestination(icon: SFIcons.sf_gearshape, label: '', selectedIcon: SFIcons.sf_gearshape_fill, isSfIcon: true),
      _buildIconDestination(icon: Icons.logout_outlined, selectedIcon: Icons.logout, label: ''),
    ];
  }

  static List<NavigationDestination> studentDestinations() {
    return [
      _buildIconDestination(icon: SFIcons.sf_message, selectedIcon: SFIcons.sf_message_fill, label: '', isSfIcon: true),
      _buildIconDestination(icon: Icons.lunch_dining_outlined, selectedIcon: Icons.lunch_dining, label: ''),
      _buildIconDestination(icon: SFIcons.sf_gearshape, label: '', selectedIcon: SFIcons.sf_gearshape_fill, isSfIcon: true),
      _buildIconDestination(icon: SFIcons.sf_lock, label: '', selectedIcon: SFIcons.sf_lock_fill, isSfIcon: true),
    ];
  }

  static List<NavigationDestination> adminDestination() {
    return [
      _buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      _buildIconDestination(icon: SFIcons.sf_gearshape, selectedIcon: SFIcons.sf_gearshape_fill, label: '', isSfIcon: true),
      _buildIconDestination(icon: Icons.logout_outlined, selectedIcon: Icons.logout, label: ''),
    ];
  }

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

  static List<NavigationDestination> defaultDestinations() {
    return [
      _buildIconDestination(icon: Icons.home_outlined, selectedIcon: Icons.home, label: ''),
      _buildIconDestination(icon: Icons.logout_outlined, selectedIcon: Icons.logout, label: ''),
    ];
  }
}
