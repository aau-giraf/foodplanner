import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodplanner/services/fetch_auth.dart';

class ApiConfig {
  static const String _defaultUrl = 'http://localhost:8080';

  static String get baseUrl {
    try {
      return dotenv.env['API_URL'] ?? _defaultUrl;
    } catch (_) {
      return _defaultUrl;
    }
  }

  static AuthService? _authService;
  static AuthService get authService {
    return _authService ??= AuthService(apiUrl: baseUrl);
  }
}
