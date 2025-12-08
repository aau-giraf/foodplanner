import 'dart:convert';
import 'package:foodplanner/auth/auth_provider.dart';
import 'package:foodplanner/models/user.dart';
import 'package:foodplanner/models/user_roles.dart';
import 'package:foodplanner/services/fetch_auth.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String apiUrl;

  UserService({required this.apiUrl});

  Future<User> fetchUser(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(Uri.parse('$apiUrl/api/Admin/Get/${id}'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final filteredJson = {
        'id': json['id'],
        'first_name': json['firstName'],
        'last_name': json['lastName'],
        'email': json['email'],
        'role': json['role'],
        'archived': json['archived'],
      };
      return User.fromJson(filteredJson);
    } else {
      throw Exception('Kunne ikke hente bruger');
    }
  }

  Future<User> fetchLoggedInUser() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(Uri.parse('$apiUrl/api/Users/GetLoggedIn'),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        });

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final filteredJson = {
        'id': json['id'],
        'first_name': json['first_name'],
        'last_name': json['last_name'],
        'email': json['email'],
        'role': json['role'],
        'archived': json['archived'],
      };
      return User.fromJson(filteredJson);
    } else {
      throw Exception('Kunne ikke hente bruger');
    }
  }

  Future<List<User>> fetchApproveUsers() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
      Uri.parse('$apiUrl/api/Admin/GetNotApproved'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map<User>((json) => User.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<bool> updateApproveUsers(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.put(
      Uri.parse('$apiUrl/api/Admin/UpdateRoleApproved/$id'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id': id,
        'role_approved': true,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update and approve users');
    }
  }

  /*Future<bool> unapproveUsers(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.delete(
      Uri.parse('$apiUrl/api/Admin/Delete/$id'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      print(
          'Failed to unapprove users: ${response.statusCode} ${response.body}');
      throw Exception('Failed to unapprove users');
    }
  }*/

  Future<http.Response> createUser(String firstName, String lastName,
      String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/Users/Create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role
      }),
    );

    return response;
  }

  Future<http.Response> createUserPupil(String firstName, String lastName,
      String email, String password, List<int> parentIds, int classId) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/Users/CreateUserChildren'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'parentIds': parentIds,
        'classId': classId,
      }),
    );

    print(classId);

    return response;
  }

  Future<http.Response> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/api/Users/Login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    return response;
  }

  Future<List<User>> fetchAllGuardians() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http
        .get(Uri.parse('$apiUrl/api/Admin/GetAll'), headers: <String, String>{
      'Authorization': 'Bearer $jwtToken',
    });
    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);

      return usersJson
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Kunne ikke hente forældre');
    }
  }

  Future<List<User>> fetchAllUsers() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
      Uri.parse('$apiUrl/api/Admin/GetAll'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map<User>((json) => User.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<dynamic> updateArchived(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.put(
      Uri.parse('$apiUrl/api/Admin/UpdateArchived/$id'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      return {'Message': 'Kunne ikke opdatere brugeren'};
    }
  }

  Future<dynamic> userInfo(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.get(
      Uri.parse('$apiUrl/api/Users/GetLoggedIn'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final filteredJson = {
        'id': json['id'],
        'first_name': json['first_name'],
        'last_name': json['last_name'],
        'email': json['email'],
        'role': json['role'],
        'archived': json['archived'],
      };
      return User.fromJson(filteredJson);
    } else {
      throw Exception('Kunne ikke hente bruger');
    }
  }

  Future<dynamic> updatePincode(String updatedPincode) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response =
        await http.put(Uri.parse('$apiUrl/api/Users/UpdatePinCode'),
            headers: {
              'Authorization': 'Bearer $jwtToken',
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'PinCode': updatedPincode,
            }));
    if (response.statusCode != 200) {
      return {'Message': 'Kunne ikke opdatere brugerens pinkode'};
    }
  }

  Future<dynamic> updatePassword(String updatedPassword) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response =
        await http.put(Uri.parse('$apiUrl/api/Users/UpdatePassword'),
            headers: {
              'Authorization': 'Bearer $jwtToken',
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'password': updatedPassword,
            }));

    return response;
  }

  Future<http.Response> updateUser(
      int id, String firstName, String lastName, String email) async {
   //developer.log("Knap trykket på");
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.put(
      Uri.parse('$apiUrl/api/Users/UpdateLoggedIn'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      }),
    );

    return response;
  }

  Future<dynamic> deleteLoggedInUser() async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.delete(
      Uri.parse('$apiUrl/api/Users/DeleteLoggedInUser'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
        'accept': '*/*'
      }
    );

    return response;
  }

  /// The endpoint currently requires an email. In the future, would be nice if it didn't.
  Future<UserRoles> loginPupil(String email, String code) async {
    print("calling LoginChild with $code and $email");
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.post(
      Uri.parse('$apiUrl/api/Users/LoginChild'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'email': email,
        'code': code
      }),
    );


    if (response.statusCode != 200) {
      print(response.body);
      var error = jsonDecode(response.body);
      throw AuthException(error['Message'] ?? 'Failed to load auth data');
    }
    
    final data = jsonDecode(response.body);
    final String jwt = data['jwt'];
    final bool roleApproved = data['roleApproved'];
    String roleValueString = data['role'];

    // print(jwt);
    // print(roleApproved);
    // print(roleValueString);

    UserRoles authRole = UserRoles.fromString(roleValueString);

    await AuthProvider().login(authRole, jwt, roleApproved);
    
    return authRole;
  }
  
  Future<List<GuardianUser>> fetchAllGuardiansByPupilUserId(int id) async {
    final jwtToken = await AuthProvider().retrieveToken(); 
    final response = await http.get( 
      Uri.parse(
        '$apiUrl/api/Childrens/GetParentsByChildId/$id/parents'), 
        headers: <String, String>{
         'accept': 'text/plain', 
         'Authorization': 'Bearer $jwtToken', 
        }
    ); 
    if (response.statusCode == 200) { 
      final List<dynamic> usersJson = jsonDecode(response.body); 
      final guardians = usersJson .map((json) => GuardianUser.fromJson(json as Map<String, dynamic>)) .toList(); 
      return guardians; 
    } else { 
      throw Exception('Kunne ikke hente forældre'); 
    }
  }

  Future<dynamic> deleteUser(int id) async {
    final jwtToken = await AuthProvider().retrieveToken();
    final response = await http.delete(
      Uri.parse('$apiUrl/api/Admin/Delete/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
        'accept': '*/*'
      }
    );
    return response;
  }
}