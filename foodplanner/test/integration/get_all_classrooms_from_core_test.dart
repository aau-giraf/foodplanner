import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('GetAll classrooms from core matches foodplanner', () async {
    // you need core-v2 running in a docker container for the test to pass!
    // arrange
      // the file is the response captured from foodplanner's /api/Classrooms/GetAll, so core is compared against it without foodplanner running
      // if the endpoint in foodplannerAPI this test will not fail!
      // if the seeding data is changed in core-v2 this test will also fail!
    final client = http.Client();
    
    // act
    final responseCore = await client.get(Uri.parse('http://localhost:8081/legacy/class/GetAll'));
    final mockResponseFoodplannerAPI =  jsonDecode(File('test/integration/mock_responses_from_fp_api/classrooms_get_all.json').readAsStringSync());

    // assert
    expect(responseCore.statusCode, 200);
    expect(jsonDecode(responseCore.body), mockResponseFoodplannerAPI);
    client.close();
  });
}
