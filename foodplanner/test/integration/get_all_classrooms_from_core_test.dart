import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('GetAll classrooms returns 200', () async {
    final client = http.Client();
    final response = await client.get(Uri.parse('http://localhost:8080/legacy/class/GetAll'));

    expect(response.statusCode, 200);
    client.close();
  });
}