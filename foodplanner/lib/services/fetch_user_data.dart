import 'package:jwt_decoder/jwt_decoder.dart';

class FetchUserData {
  static int decodeUserIDFromJWT(String jwtToken) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);
    var id = decodedToken['id'];
    return id;
  }
}