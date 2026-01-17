// test/mocks/mock_auth_provider.dart

import 'package:flutter/material.dart';

class MockAuthProvider extends ChangeNotifier {
  bool loggedOut = false;

  Future<void> logout() async {
    loggedOut = true;
  }
}