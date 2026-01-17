import 'package:mockito/annotations.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/auth/auth_provider.dart';

@GenerateMocks([UserService, AuthProvider])
void main() {}