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
  
}
