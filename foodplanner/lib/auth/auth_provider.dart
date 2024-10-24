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
  int? _userId;

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
  int? get userId => _userId;

  Future<void> login(
      ROLES role, String token, bool isApproved, int userId) async {
    _isApproved = isApproved;
    _isLoggedIn = true;
    _userRole = role;
    _jwtToken = token;
    _userId = userId;
    await _secureStorage.write(key: 'isApproved', value: isApproved.toString());
    await _secureStorage.write(key: 'isLoggedIn', value: 'true');
    await _secureStorage.write(key: 'userRole', value: role.toString());
    await _secureStorage.write(key: 'jwtToken', value: token);
    await _secureStorage.write(key: 'userId', value: userId.toString());
    notifyListeners();
  }

  Future<void> logout() async {
    _isApproved = null;
    _isLoggedIn = false;
    _userRole = null;
    _jwtToken = null;
    _userId = null;
    await _secureStorage.delete(key: 'isApproved');
    await _secureStorage.delete(key: 'isLoggedIn');
    await _secureStorage.delete(key: 'userRole');
    await _secureStorage.delete(key: 'jwtToken');
    await _secureStorage.delete(key: 'userId');
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
    int? userId = int.tryParse(await _secureStorage.read(key: 'userId') ?? '');
    _userId = userId;
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
