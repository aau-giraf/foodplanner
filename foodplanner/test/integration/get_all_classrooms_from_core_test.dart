import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodplanner/services/school_class_service.dart';
import 'package:pact_dart/pact_dart.dart';

const contractDirectory = 'contracts';

void main() {
  // Pact merges into an existing file, so removed interactions would stay in
  // the contract unless the file is deleted first.
  setUpAll(() {
    final contract = File('$contractDirectory/foodplanner-core.json');
    if (contract.existsSync()) {
      contract.deleteSync();
    }
  });

  test('GetAll classrooms from core matches foodplanner', () async {
    // the point of this test is to establish the consumer side of the contract in CDC testing using Pact
    // this test 
    final pact = PactMockService(
      'foodplanner',   // consumer name, goes in the file
      'core',      // provider name, goes in the file
      port: 1235,        // the port which the Mock server runs on 
    );

    pact
        .newInteraction()
        .given('classes exists')
        .uponReceiving('a request for all classes')
        .withRequest('GET', '/api/Classrooms/GetAll')
        .willRespondWith(200,
        headers: {'Content-Type': 'application/json; charset=utf-8'},
        body: PactMatchers.EachLike([
          {
            'classId': PactMatchers.IntegerLike(1), // inserts id = 1 in the mock server's eventual response
            // regex matches strings of the form: "1.A", "2.B", "3.Y" etc.
            'className': PactMatchers.Term(r'[0-9]\.[A-Z]', "1.Y"), // inserts className = 1.Y in the mock server's eventual response
          }
        ], min: 1));

    pact.run();
    
    // tests the actual service method against the pact mock server's URL. 
    final service = SchoolClassService(apiUrl: 'http://${pact.addr}');
    final classes = await service.fetchAllClasses();

    expect(classes.first.classId, 1);
    expect(classes.first.className, '1.Y');

    // when the test passes, what is written to the contract directory is the 
    // ideal representation of the response object which is required from core-v2
    pact.writePactFile(directory: contractDirectory);
    pact.reset();
  });
}
