// test/mocks/mock_user_service.dart

import 'package:foodplanner/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:foodplanner/models/user_roles.dart';

class MockUserService {
  // Simulerer den loggede bruger, der hentes ved opstart
  Future<User> fetchLoggedInUser({bool isAdmin = false}) async {
    await Future.delayed(Duration(milliseconds: 10)); // Simuler en forsinkelse
    return User(
      id: 1,
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'Bruger',
      role: isAdmin ? UserRoles.of([Role.admin]) : UserRoles.of([Role.teacher]),
      archived: false,
    );
  }

  // Simulerer hentning af alle brugere (bruges til admin-check)
  Future<List<User>> fetchAllUsers() async {
    await Future.delayed(Duration(milliseconds: 10));
    return [
      await fetchLoggedInUser(isAdmin: true), // Den loggede admin
      User(
        id: 2,
        email: 'admin2@example.com',
        firstName: 'Admin',
        lastName: 'Bruger',
        role: UserRoles.of([Role.admin]),
        archived: false,
      ),
      User(
        id: 3,
        email: 'user1@example.com',
        firstName: 'Teacher',
        lastName: 'Bruger',
        role: UserRoles.of([Role.teacher]),
        archived: false,
      ),
    ];
  }

  // Simulerer opdatering af brugerinfo
  Future<void> updateUser(int id, String firstName, String lastName, String email) async {
    await Future.delayed(Duration(milliseconds: 10));
    // Simuler succes
  }

  // Simulerer opdatering af adgangskode
  Future<void> updatePassword(String password) async {
    await Future.delayed(Duration(milliseconds: 10));
    // Simuler succes
  }

  // Simulerer opdatering af pinkode
  Future<void> updatePincode(String pincode) async {
    await Future.delayed(Duration(milliseconds: 10));
    // Simuler succes
  }

  // Simulerer sletning af bruger
  Future<http.Response> deleteLoggedInUser({int statusCode = 204}) async {
    await Future.delayed(Duration(milliseconds: 10));
    // Simulerer HTTP-svar
    return http.Response('', statusCode);
  }
}