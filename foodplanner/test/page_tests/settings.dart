import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:foodplanner/services/user_service.dart';
import 'package:foodplanner/pages/settings/settings.dart';
import 'package:foodplanner/services/api_config.dart';

void main(){
  test('Fetch the user information', () async {
    //final fetchUser = fetchUser();
    final UserService service = UserService(apiUrl: ApiConfig.baseUrl);
    final user = await service.fetchLoggedInUser();
    expect(user.email, "m@m.dk");
  });
}