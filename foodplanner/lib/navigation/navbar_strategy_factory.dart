import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:foodplanner/routes/user_roles.dart';
import 'package:foodplanner/navigation/navigation_destination_builder.dart';

class NavBarDestinationFactory {
  static List<NavigationDestination> getNavBarDestinations(ROLES role) {
    switch(role) {
      case ROLES.teacher:
        return NavigationDestinationBuilder.teacherDestinations();
      
      case ROLES.guardian:
        return NavigationDestinationBuilder.guardianDestinations();
      
      case ROLES.student:
        return NavigationDestinationBuilder.studentDestinations();

      case ROLES.admin:
        return NavigationDestinationBuilder.adminRoleDestination();
      
      default:
        return NavigationDestinationBuilder.defaultDestinations();
    }

    /*
    if(role == ROLES.teacher || role == ROLES.guardian) {
      return _teacherParentDestination();
    } else if (role == ROLES.student){
      return NavigationDestinationBuilder.studentDestinations();
    } else if (role == ROLES.admin) {
      return NavigationDestinationBuilder.adminDestination();
    } else {
      return _defaultDestinations();
    }*/
  }

    /*
    if(role == ROLES.teacher || role == ROLES.guardian) {
      return _teacherParentDestination();
    } else if (role == ROLES.student){
      return NavigationDestinationBuilder.studentDestinations();
    } else if (role == ROLES.admin) {
      return NavigationDestinationBuilder.adminDestination();
    } else {
      return _defaultDestinations();
    }*/


/*
  static List<NavigationDestination> _teacherParentDestination() {
    return [
      NavigationDestination(
      selectedIcon: Icon(
        Icons.home,
        color: Colors.white,
      ),
        icon: Icon(Icons.home), 
        label: ''
      ),
      NavigationDestination(
      selectedIcon: Icon(
        Icons.escalator_warning,
        color: Colors.white,
      ),
        icon: Icon(Icons.escalator_warning),
        label: ''
      ),
      NavigationDestination(
      selectedIcon: SFIcon(
        SFIcons.sf_gearshape_fill,
        color: Colors.white,
      ),
        icon: SFIcon(SFIcons.sf_gearshape),
        label: '',
      ),
      NavigationDestination(
      selectedIcon: Icon(
        Icons.logout,
        color: Colors.white,
      ),
        icon: Icon(Icons.logout),
        label: '',
      )
    ];
  }
  */

/*
  static List<NavigationDestination> _studentDestination() {
    return[
      NavigationDestination(
      selectedIcon: SFIcon(
        SFIcons.sf_message_fill,
        color: Colors.white,
      ),
      icon: SFIcon(SFIcons.sf_message),
      label: 'Feedback',
      ),

      NavigationDestination(
        selectedIcon: Icon(
          Icons.lunch_dining,
          color: Colors.white,
        ),
        icon: Icon(Icons.lunch_dining),
        label: 'Madpakke',
      /*selectedIcon: SFIcon(
        SFIcons.sf_gift_fill,
        color: Colors.white,
      ),
      icon: SFIcon(SFIcons.sf_gift),
      label: 'Madpakke',*/
      ),

      NavigationDestination(
      selectedIcon: SFIcon(
        SFIcons.sf_gearshape_fill,
        color: Colors.white,
      ),
      icon: SFIcon(SFIcons.sf_gearshape),
      label: 'Indstillinger',
      ),
    
      NavigationDestination(
      selectedIcon: SFIcon(
        SFIcons.sf_lock,
        color: Colors.white,
      ),
      icon: SFIcon(SFIcons.sf_lock),
      label: 'lock',
     ),
    ];
  }

*/
/*
  static List<NavigationDestination> _adminDestination() {
    return [
      NavigationDestination(
      selectedIcon: Icon(
        Icons.home,
        color: Colors.white,
      ),
        icon: Icon(Icons.home), 
        label: 'home'
      ),

      NavigationDestination(
      selectedIcon: SFIcon(
        SFIcons.sf_gearshape_fill,
        color: Colors.white,
      ),
      icon: SFIcon(SFIcons.sf_gearshape),
      label: 'Indstillinger',
      ),
      
      NavigationDestination(
      selectedIcon: Icon(
        Icons.logout,
        color: Colors.white,
      ),
        icon: Icon(Icons.logout),
        label: 'Logud',
      )
    ];
  }

*/
/*
  static List<NavigationDestination> _defaultDestinations() {
    return [
      NavigationDestination(
        icon: Icon(Icons.home), 
        label: 'Hjem'
      ),
      
    ];
  }
*/
  
}

