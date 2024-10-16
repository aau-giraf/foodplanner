import 'package:foodplanner/services/fetch_auth.dart';

class ApiConfig {

  static final AuthService authService = AuthService(apiUrl: 'http://localhost');
  static const String baseUrl = 'http://localhost:5432';

}