import 'package:foodplanner/services/fetch_auth.dart';
import 'package:http/io_client.dart';

class ApiConfig {
  static final AuthService authService =
      AuthService(apiUrl: 'https://0812sjhc-8080.euw.devtunnels.ms');
  static const String baseUrl = 'https://0812sjhc-8080.euw.devtunnels.ms';
}
