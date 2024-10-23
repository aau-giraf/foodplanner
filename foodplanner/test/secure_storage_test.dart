import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/routes/user_roles.dart';  
import '../test/secure_storage_test.mocks.dart';  // Generated mock file from the command: flutter pub run build_runner build

void main() {
  late AuthProvider authProvider;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    authProvider = AuthProvider(secureStorage: mockSecureStorage);  // Inject the mock
  });

  group('AuthProvider', () {
    test('login sets values correctly and writes to secure storage', () async {
      // Arrange mock data
      final role = ROLES.admin;
      final token = 'fake_jwt_token';
      final isLoggedIn = true;

      // Act / we call login method from auth_provider.dart
      await authProvider.login(role, token, isLoggedIn);

      // Assert the values are set correctly through login
      expect(authProvider.isLoggedIn, isLoggedIn);
      expect(authProvider.userRole, role);
      expect(authProvider.jwtToken, token);

      // We verify that the method is called once and once only, and that the values are in the proper fields matching their keys
      verify(mockSecureStorage.write(key: 'isLoggedIn', value: isLoggedIn.toString())).called(1);
      verify(mockSecureStorage.write(key: 'userRole', value: role.toString())).called(1);
      verify(mockSecureStorage.write(key: 'jwtToken', value: token)).called(1);
    });

    test('logout clears values and deletes from secure storage', () async {

      //add fake data from login here
      // Act
      await authProvider.logout();

      // Assert
      expect(authProvider.isLoggedIn, false);
      expect(authProvider.userRole, isNull);
      expect(authProvider.jwtToken, isNull);

      // Verify secure storage deletes
      verify(mockSecureStorage.delete(key: 'isLoggedIn')).called(1);
      verify(mockSecureStorage.delete(key: 'userRole')).called(1);
      verify(mockSecureStorage.delete(key: 'jwtToken')).called(1);
    });

    test('retrieveToken returns the token from secure storage', () async {
      // Arrange
      final token = 'fake_jwt_token';
      when(mockSecureStorage.read(key: 'jwtToken')).thenAnswer((_) async => token);

      // Act
      final retrievedToken = await authProvider.retrieveToken();

      // Assert
      expect(retrievedToken, token);
      verify(mockSecureStorage.read(key: 'jwtToken')).called(1);
    });

    test('loadFromStorage loads data correctly from secure storage', () async {
      // Arrange
      when(mockSecureStorage.read(key: 'isLoggedIn')).thenAnswer((_) async => 'true');
      when(mockSecureStorage.read(key: 'userRole')).thenAnswer((_) async => ROLES.admin.toString());

      // Act
      await authProvider.loadFromStorage();

      // Assert
      expect(authProvider.isLoggedIn, true);
      expect(authProvider.userRole, ROLES.admin);
      verify(mockSecureStorage.read(key: 'isLoggedIn')).called(1);
      verify(mockSecureStorage.read(key: 'userRole')).called(1);
    });

  });
}
