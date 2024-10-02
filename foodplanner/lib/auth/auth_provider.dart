// auth_provider.dart
import 'package:flutter/material.dart';
import '../routes/user_roles.dart'; 

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  ROLES? _userRole;

  bool get isLoggedIn => _isLoggedIn;
  ROLES? get userRole => _userRole;

  // Mock login function till we make the real one
  Future<void> login(ROLES role) async {
    _isLoggedIn = true;
    _userRole = role;
    notifyListeners();  // Notifies any listeners of the state change
  }

  // Mock logout function till we make the real one
  void logout() {
    _isLoggedIn = false;
    _userRole = null;
    notifyListeners();
  }

  // mock function to check functionality
  Future<void> checkUserStatus() async {
    // Simulate a delay (e.g., fetching user data from a backend or shared preferences)
    await Future.delayed(const Duration(seconds: 2));
    _isLoggedIn = false; // Set the initial login state
    _userRole = null;    // Set the initial role
    notifyListeners();
  }
}
