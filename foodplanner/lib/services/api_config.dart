import 'package:foodplanner/services/fetch_auth.dart';
import 'package:http/io_client.dart';

class ApiConfig {

  static final AuthService authService = AuthService(apiUrl: 'http://localhost:8080');
  static const String baseUrl = 'http://localhost:8080';

}