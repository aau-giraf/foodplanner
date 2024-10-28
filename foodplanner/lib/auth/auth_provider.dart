// auth_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../routes/user_roles.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage;
  bool? _isApproved;
  bool _isLoggedIn = false;
  ROLES? _userRole;
  String? _jwtToken;

  AuthProvider({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              iOptions:
                  IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  bool? get isApproved => _isApproved;
  bool get isLoggedIn => _isLoggedIn;
  ROLES? get userRole => _userRole;
  String? get jwtToken => _jwtToken;

  Future<void> login(ROLES role, String token, bool isApproved) async {
    _isApproved = isApproved;
    _isLoggedIn = true;
    _userRole = role;
    _jwtToken = token;
    await _secureStorage.write(key: 'isApproved', value: isApproved.toString());
    await _secureStorage.write(key: 'isLoggedIn', value: 'true');
    await _secureStorage.write(key: 'userRole', value: role.toString());
    await _secureStorage.write(key: 'jwtToken', value: token);
    notifyListeners();
  }

  Future<void> logout() async {
    _isApproved = null;
    _isLoggedIn = false;
    _userRole = null;
    _jwtToken = null;
    await _secureStorage.delete(key: 'isApproved');
    await _secureStorage.delete(key: 'isLoggedIn');
    await _secureStorage.delete(key: 'userRole');
    await _secureStorage.delete(key: 'jwtToken');
    notifyListeners();
  }

  bool hasRole(ROLES role) {
    loadFromStorage();
    return _isLoggedIn && _userRole == role;
  }

  Future<void> setRole(ROLES role) async {
    _isLoggedIn = true;
    _userRole = role;
    await _secureStorage.write(key: 'userRole', value: role.toString());
    notifyListeners();
  }

  Future<void> loadFromStorage() async {
    String? isApproved = await _secureStorage.read(key: 'isApproved');
    String? isLoggedIn = await _secureStorage.read(key: 'isLoggedIn');
    String? userRole = await _secureStorage.read(key: 'userRole');
    _isApproved = isApproved == 'true';
    _isLoggedIn = isLoggedIn == 'true';
    _userRole = userRole != null
        ? ROLES.values.firstWhere((e) => e.toString() == userRole)
        : null;
    notifyListeners();
  }

  Future<String?> retrieveToken() async {
    _jwtToken = await _secureStorage.read(key: 'jwtToken');
    notifyListeners();
    return _jwtToken;
  }
}
