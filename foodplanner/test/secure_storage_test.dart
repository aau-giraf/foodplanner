// secure_storage_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/routes/user_roles.dart';
import '../test/secure_storage_test.mocks.dart';  // Generated mock file from the command: flutter pub run build_runner build

@GenerateMocks([FlutterSecureStorage])
import 'secure_storage_test.mocks.dart';

Future<void> main() async {
  late AuthProvider authProvider;
  late MockFlutterSecureStorage mockSecureStorage;
  
  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    authProvider = AuthProvider(secureStorage: mockSecureStorage);  // Inject the mock
  });


   test('login sets values correctly and write to secure storage', () async {
    final role = ROLES.admin;
    final token = 'fakeToken';
    final isLoggedIn = true;

    // Act
    await authProvider.login(role, token, isLoggedIn);

  
    expect(authProvider.isLoggedIn, isLoggedIn);  
    expect(authProvider.userRole, role);
    expect(authProvider.jwtToken, token);

    verify(mockSecureStorage.write(key    : 'isLoggedIn', value: isLoggedIn.toString()));
    verify(mockSecureStorage.write(key: 'userRole', value: role.toString()));
    verify(mockSecureStorage.write(key    : 'jwtToken', value: token));
  

});
}

