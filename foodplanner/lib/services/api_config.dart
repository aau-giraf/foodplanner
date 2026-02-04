import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodplanner/services/fetch_auth.dart';

class ApiConfig {
  static String get baseUrl => dotenv.env['API_URL'] ?? 'http://localhost:8080';

  static AuthService get authService => AuthService(apiUrl: baseUrl);
}
