import 'package:foodplanner/services/fetch_auth.dart';

class ApiConfig {
  static final AuthService authService =
      AuthService(apiUrl: 'http://10.27.29.90:8080');
  static const String baseUrl = 'http://10.27.29.90:8080';
}
