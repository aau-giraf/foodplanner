// auth_provider.dart
import 'package:flutter/material.dart';
import '../routes/user_roles.dart'; 

class AuthProvider with ChangeNotifier {
   bool _isLoggedIn = false;
  ROLES? _userRole;

  bool get isLoggedIn => _isLoggedIn;
  ROLES? get userRole => _userRole;

  Future<void> login(ROLES role) async {
    _isLoggedIn = true;
    _userRole = role;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userRole = null;
    notifyListeners();
  }

  bool hasRole(ROLES role) {
    return _isLoggedIn && _userRole == role;
  }
}
