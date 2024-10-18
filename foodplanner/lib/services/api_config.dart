import 'package:foodplanner/services/fetch_auth.dart';

class ApiConfig {

  static final AuthService authService = AuthService(apiUrl: 'http://localhost:8080');
  static const String baseUrl = 'http://localhost:8080';

}