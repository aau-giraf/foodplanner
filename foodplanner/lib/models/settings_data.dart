import 'package:foodplanner/models/user.dart';

// Class for containing settings data for a user 
class SettingsData {
  String firstName;
  String lastName;
  String email;
  String password;
  String pincode;

  SettingsData ({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password = '',
    this.pincode = '',
  });
  
  factory SettingsData.fromUser(User user) {
    return  SettingsData(
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
    );
  }
}